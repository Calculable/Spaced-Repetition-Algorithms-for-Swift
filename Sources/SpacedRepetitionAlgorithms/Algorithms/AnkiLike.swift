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
    
    static let defaultReview = Review(intervalDays: 1, numberOfCorrectReviewsInARow: 0, easeFactor: EaseFactors.defaultEaseFactor) //shouldn't the interval be 1.0 to be consistent with the other algorithms?
    
    let addFuzzyness: Bool

    init(addFuzzyness: Bool = false) {
        self.addFuzzyness = addFuzzyness
    }
    
    private func daysFromMinutes(minutes: Double) -> Double {
        return minutes / (24.0 * 60.0)
    }
    
    // Compute amount of fuzz to apply to an interval to avoid bunching up reviews on the same cards.
    private func fuzzForInterval(interval: Double) -> Double {
        var fuzzRange: Double
        if (interval < 2) {
            fuzzRange = 0
        } else if (interval == 2) {
            fuzzRange = 1
        } else if (interval < 7) {
            fuzzRange = round(interval * 0.25)
        } else if (interval < 30) {
            fuzzRange = max(2, round(interval * 0.25))
        } else {
            fuzzRange = max(4, round(interval * 0.05))
        }
        
        return Double.random(in: 0..<1) * fuzzRange - fuzzRange * 0.5
    }
    
    internal func nextReviewEaseFactor(lastReview: Review = defaultReview, currentEvaluation: Evaluation) -> Double {

        if (lastReview.numberOfCorrectReviewsInARow <= 2) {
            // Still in learning phase, so do not change efactor
            return lastReview.easeFactor
        }
        
        // Reviewing phase
        if (!currentEvaluation.score.wasRecalled()) {
            // Reduce efactor
            return max(EaseFactors.veryDifficult, lastReview.easeFactor - 0.20)
        }
        
        // Passed
        return max(EaseFactors.veryDifficult, lastReview.easeFactor + (0.1 - (5 - Double(currentEvaluation.score.rawValue)) * (0.08+(5 - Double(currentEvaluation.score.rawValue))*0.02)))
    }
    
    
    internal func nextReviewInterval(lastReview: Review = defaultReview, currentEvaluation: Evaluation, easeFactor: Double) -> Double {

        var interval: Double
        
        if (lastReview.numberOfCorrectReviewsInARow <= 2) {
            // Still in learning phase
            
            // if did failed card, reset n and interval
            if (!currentEvaluation.score.wasRecalled()) {
                // Due in 1minute
                interval = 1.0/(24.0*60.0)
            } else if (currentEvaluation.score.rawValue < 5) {
                
                // first interval = 1min
                // second interval = 10min
                // third interval = 24h
                
                if (lastReview.numberOfCorrectReviewsInARow == 0) {
                    interval = daysFromMinutes(minutes: 1.0)
                } else if (lastReview.numberOfCorrectReviewsInARow == 1) {
                    interval = daysFromMinutes(minutes: 10.0)
                } else {
                    interval = 1.0
                }
            } else {
                interval = 4.0
            }
        } else {
            // Reviewing phase
            if (currentEvaluation.score.rawValue < 3) {
                // Failed, so reset interval to 1m
                interval = daysFromMinutes(minutes: 1.0)
            } else {
                // Passed
                let latenessDays = max(0, currentEvaluation.lateness * lastReview.intervalDays)
                var latenessBonus = 0.0
                if (latenessDays > 0) {
                    if (currentEvaluation.score.rawValue >= 5) {
                        latenessBonus = latenessDays
                    } else if (currentEvaluation.score.rawValue >= 4) {
                        latenessBonus = latenessDays / 2.0
                    } else {
                        latenessBonus = latenessDays / 4.0
                    }
                }
                
                var workingEfactor = easeFactor
                
                if (currentEvaluation.score.rawValue >= 3 && currentEvaluation.score.rawValue < 4) {
                    // hard card. increase interval by 1.2 instead of whatever efactor was
                    interval = ceil(lastReview.intervalDays * 1.2) //redundant, evt. nachfragen
                    
                    // ding score since this was hard
                    workingEfactor = max(EaseFactors.veryDifficult, workingEfactor - 0.15)
                } else if (currentEvaluation.score.rawValue >= 5) {
                    // easy card, so give bonus to workingEfactor
                    workingEfactor = max(1.3, workingEfactor + 0.15)
                }
                
                interval = ceil((lastReview.intervalDays + latenessBonus) * workingEfactor)
                
                
                if (addFuzzyness) {
                    // Add some proportional "fuzz" to interval to avoid bunching up reviews
                    interval += fuzzForInterval(interval: interval)
                }

            }
        }
        
        return interval
        
        
    }
    
}
