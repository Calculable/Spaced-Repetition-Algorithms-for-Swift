import Foundation

///This algorithm is used for the app „Fresh Cards“. It works similar like the Anki- and the SuperMemo2-algorithms. The lateness or earliness of a review is considered during the calculation of the next interval. The algorithm considers that it is easier to recall a learning unit if it is reviewed too early and more difficult if it is reviewed too late. A bit of randomness is included to prevent that multiple flashcards get bunched together. Compared to anki, the initial intervals are longer. Original Source in JavaScript: https://www.freshcardsapp.com/srs/simulator/
class FreshCards: SpacedRepetitionAlgorithm {
        
    /// Controls wether a random value should be added to the time intervals. If this option is turned on, it prevents that the same learning units are always "grouped" together.
    let addFuzzyness: Bool
    
    init(addFuzzyness: Bool = false) {
        self.addFuzzyness = addFuzzyness
    }
    
    fileprivate func futureWeight(_ currentEvaluation: Evaluation) -> Double {
        let normalizedEarliness = (1.0 + currentEvaluation.lateness)
        
        //put the value into a curved function:
        let futureWeight = min(exp(normalizedEarliness * normalizedEarliness) - 1.0, 1.0)
        return futureWeight
    }
    
    fileprivate func futureEaseFactor(_ lastReview: Review, _ currentEvaluation: Evaluation, _ futureWeight: Double) -> Double {
        let currentWeight = 1.0 - futureWeight

        // The score is extrapolated to the future. The algorithm predicts what the future score is likely to be (it assumes that the score will decrease since it is harder to recall "older" learning units)
        let predictedFutureScore = currentWeight * currentEvaluation.scoreValue + futureWeight * 3.0
        
        // the assumed future ease factor
        return max(EaseFactors.veryDifficult, lastReview.easeFactor + (0.1 - (5 - predictedFutureScore) * (0.08+(5 - predictedFutureScore)*0.02)))
        
    }

    
    fileprivate func nextReviewEaseFactorForEarlyReview(_ currentEvaluation: Evaluation, _ lastReview: Review) -> Double {
        let futureWeight = futureWeight(currentEvaluation)
        let currentWeight = 1.0 - futureWeight
        let futureEasefactor = futureEaseFactor(lastReview, currentEvaluation, futureWeight)
        return lastReview.easeFactor * currentWeight + futureEasefactor * futureWeight
    }
    
    fileprivate func nextReviewEaseFactorForNonEarlyReview(_ currentEvaluation: Evaluation, _ lastReview: Review) -> Double {
        var latenessScoreBonus = 0.0

        if (currentEvaluation.lateness >= 0.10 && currentEvaluation.score.wasRecalled()) {
            // If the review was late and still correct (recalled) a bonus is added to the interval because it is assumed that "old" knowledge is harder to recall.
            let latenessFactor = min(1.0, currentEvaluation.lateness)
            let scoreFactor = 1.0 + (currentEvaluation.scoreValue - 3.0) / 4.0
            latenessScoreBonus = 1.0 * latenessFactor * scoreFactor
        }
        
        let adjustedScore = latenessScoreBonus + currentEvaluation.scoreValue
        return max(EaseFactors.veryDifficult, lastReview.easeFactor + (0.1 - (5 - adjustedScore) * (0.08+(5 - adjustedScore)*0.02)))
    }
    
    internal func nextReviewEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {
        if (lastReview.isInLearningPhase) {
            return lastReview.easeFactor // the ease factor is not changed during the learning phase
        }
            
        if (currentEvaluation.score.wasRecalled()) {
            if (currentEvaluation.lateness >= -0.10) {
                return nextReviewEaseFactorForNonEarlyReview(currentEvaluation, lastReview)
            } else {
                return nextReviewEaseFactorForEarlyReview(currentEvaluation, lastReview)
            }
        } else {
            // Reduce the ease factor (the information unit is harder than expected)
            return max(EaseFactors.veryDifficult, lastReview.easeFactor - 0.20)
        }
    }
    
    
    fileprivate func nextReviewIntervalForLearningPhase(_ currentEvaluation: Evaluation, _ lastReview: Review) -> Double {
        var interval: Double
        
        if (currentEvaluation.score.wasRecalled()) {
            switch lastReview.numberOfCorrectReviewsInARow {
            case 0: interval = numberOfDays(fromMinutes: 30)
            case 1: interval = 0.5 //12 hours
            default: interval = 1
            }
        } else {
            interval = numberOfDays(fromMinutes: 30)
        }
        
        interval = addFuzz(originalValue: interval, fuzzFactor: 0.1)
        return interval
    }
    
    fileprivate func nextReviewIntervalForNonEarlyReview(_ currentEvaluation: Evaluation, _ lastReview: Review, _ easeFactor: Double) -> Double {
        var intervalAdjustment = 1.0
        
        if (currentEvaluation.lateness < 0.10 && currentEvaluation.score >= Score.recalled_but_difficult && currentEvaluation.score < Score.recalled) {
            //non-late difficult review
            intervalAdjustment = 0.8
        }
        
        if (lastReview.numberOfCorrectReviewsInARow == 0) {
            return 1
        } else if (lastReview.numberOfCorrectReviewsInARow  == 1) {
            return 6
        } else {
            return ceil(lastReview.intervalDays * intervalAdjustment * easeFactor)
        }
    }
    
    
    fileprivate func nextReviewIntervalForEarlyReview(_ currentEvaluation: Evaluation, _ lastReview: Review) -> Double {
        let futureWeight = futureWeight(currentEvaluation)
        let currentWeight = 1.0 - futureWeight
        let futureEasefactor = futureEaseFactor(lastReview, currentEvaluation, futureWeight)

        var futureInterval: Double
            
        switch lastReview.numberOfCorrectReviewsInARow {
        case 0: futureInterval = 1
        case 1: futureInterval = 6
        default: futureInterval =  ceil(lastReview.intervalDays * futureEasefactor)
        }
        
        return  lastReview.intervalDays * currentWeight + futureInterval * futureWeight
    }
    
    fileprivate func nextReviewIntervalForReviewPhase(_ currentEvaluation: Evaluation, _ lastReview: Review, _ easeFactor: Double) -> Double {
        var interval: Double
        
        if (currentEvaluation.score.wasRecalled()) {
            if (currentEvaluation.lateness >= -0.10) {
                interval = nextReviewIntervalForNonEarlyReview(currentEvaluation, lastReview, easeFactor)
            } else {
                interval = nextReviewIntervalForEarlyReview(currentEvaluation, lastReview)
            }
            interval = addFuzz(originalValue: interval, fuzzFactor: 0.05)
        } else {
            // The learning unit was not recalled, therefore it should be repeated in a short period of time
            interval = numberOfDays(fromMinutes: 30)
        }
        return interval
    }
    
    internal func nextReviewInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        if (lastReview.isInLearningPhase) {
            return nextReviewIntervalForLearningPhase(currentEvaluation, lastReview)
        } else {
            return nextReviewIntervalForReviewPhase(currentEvaluation, lastReview, easeFactor)
        }
    }
    
    
    private func addFuzz(originalValue: Double, fuzzFactor: Double) -> Double {
        if (addFuzzyness) {
            return originalValue * (1.0 + Double.random(in: 0..<1) * fuzzFactor)
        }
        return originalValue
    }
}
