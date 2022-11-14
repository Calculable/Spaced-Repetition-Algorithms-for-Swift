import Foundation

/**
* An approximation of the Anki algorithm:
*
* This is a naive implementation of Anki's algorithm. This is not 100% accurate and
* was put together based on documentation other folks wrote up on the web. Anki's
* scheduling algorithm code is tied very closely to its data model, so it's a bit
* complicated to walk through.
*
* Like SM-2, Anki's algorithm uses a 5.0 scale for measuring how well you remember a
* card during a lesson. "Failed" cards get a 2.0 score, cards you got right but had
* difficulty remember get 3.0, "good" cards get 4.0, and "easy" cards get 5.0.
*
* Here are the general notes about how the algorithm works.
*
* - initial 'n' values use short (less than 24h) intervals this is also known as the
*   "learning" phase during the learning phase, the efactor is not affected this
*   also applies if a card goes back into "re-learning"
* - first repetition is in 1 minute, 2nd in 10, 3rd 24h
* - cards you answer late, but still get right are given an efactor boost
* - "easy" cards get an additional boost to efactor (0.15) so that the interval gets
*   stretched out more for those cases
* - cards that are marked for "again" (i.e. failing) have their efactor reduced by 0.2
* - hard cards (score of 3) have efactor reduced by 0.15 and interval is increased
*   by 1.2 instead of the efactor
* - score of 4.0 (good) does not affect efactor
* - a small amount of "fuzz" is added to interval to make sure the same cards aren't
*   reviewed together as a group
*/
struct AnkiLikeAlgorithm: SpacedRepetitionAlgorithm {
        
    let addFuzzyness: Bool

    init(addFuzzyness: Bool = false) {
        self.addFuzzyness = addFuzzyness
    }
    
    // Compute amount of fuzz to apply to an interval to avoid bunching up reviews on the same cards.
    private func fuzzForInterval(interval: Double) -> Double {
        var fuzzRange: Double
        
        switch interval {
        case ..<2:
            fuzzRange = 0
        case 2:
            fuzzRange = 1
        case ..<7:
            fuzzRange = round(interval * 0.25)
        case ..<30:
            fuzzRange = max(2, round(interval * 0.25))
        default:
            fuzzRange = max(4, round(interval * 0.05))
        }
        
        return Double.random(in: 0..<1) * fuzzRange - fuzzRange * 0.5
    }
    
    internal func nextReviewEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {

        if (lastReview.numberOfCorrectReviewsInARow <= 2) { // Still in learning phase, so do not change efactor
            return lastReview.easeFactor
        }
        
        // Reviewing phase
        if (currentEvaluation.score.wasRecalled()) {
            return max(EaseFactors.veryDifficult, lastReview.easeFactor + (0.1 - (5 - currentEvaluation.scoreValue) * (0.08+(5 - currentEvaluation.scoreValue)*0.02)))
        } else {
            //passed
            return max(EaseFactors.veryDifficult, lastReview.easeFactor - 0.20)
        }
        
        
        
    }
    
    
    fileprivate func nextReviewIntervalForLearningPhase(_ currentEvaluation: Evaluation, _ lastReview: Review) -> Double {
        // Still in learning phase
        
        // if did failed card, reset n and interval
        if (!currentEvaluation.score.wasRecalled()) {
            // Due in 1minute
            return daysFromMinutes(minutes: 1)
        }
        
        if (currentEvaluation.scoreValue < 5) {
            switch lastReview.numberOfCorrectReviewsInARow {
            case 0: return daysFromMinutes(minutes: 1.0)
            case 1: return daysFromMinutes(minutes: 10.0)
            default: return 1.0
            }
        }
        
        return 4.0
    }
    
    fileprivate func latenessBonus(_ currentEvaluation: Evaluation, _ lastReview: Review) -> Double {
        let latenessValue = max(0, currentEvaluation.lateness * lastReview.intervalDays)
        
        switch currentEvaluation.score.rawValue {
            case 5: return latenessValue
            case 4: return latenessValue / 2.0
            default: return latenessValue / 4.0
        }
    }
    
    fileprivate func calculateWorkingEFactor(_ score: Score, _ easeFactor: Double) -> Double {
        switch score.rawValue {
        case 3: return max(EaseFactors.veryDifficult, easeFactor - 0.15)
        case 5: return max(1.3, easeFactor + 0.15)
        default: return easeFactor
        }
    }
    
    
    fileprivate func nextReviewIntervalForReviewingPhase(_ currentEvaluation: Evaluation, _ lastReview: Review, _ easeFactor: Double) -> Double {
        
        if (!currentEvaluation.score.wasRecalled()) {
            return daysFromMinutes(minutes: 1.0) // Failed, so reset interval to 1m
        }

        let latenessBonus = latenessBonus(currentEvaluation, lastReview)
        let workingEfactor = calculateWorkingEFactor(currentEvaluation.score, easeFactor)
        var interval = ceil((lastReview.intervalDays + latenessBonus) * workingEfactor)
            
        if (addFuzzyness) {
            // Add some proportional "fuzz" to interval to avoid bunching up reviews
            interval += fuzzForInterval(interval: interval)
        }
            
        return interval
            
    }
    
    internal func nextReviewInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {

        
        if (lastReview.numberOfCorrectReviewsInARow <= 2) {
            return nextReviewIntervalForLearningPhase(currentEvaluation, lastReview)
        } else {
            return nextReviewIntervalForReviewingPhase(currentEvaluation, lastReview, easeFactor)
        }
        
        
        
    }
    
}
