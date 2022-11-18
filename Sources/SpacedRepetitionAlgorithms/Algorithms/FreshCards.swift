import Foundation

///This algorithm is used for the app „Fresh Cards“. It works similar like the Anki- and the SuperMemo2-algorithms. The lateness or earliness of a review is considered during the calculation of the next interval. The algorithm considers that it is easier to recall a learning unit if it is reviewed too early and more difficult if it is reviewed too late. A bit of randomness is included to prevent that multiple flashcards get bunched together. Compared to anki, the initial intervals are longer. Original Source in JavaScript: https://www.freshcardsapp.com/srs/simulator/
public class FreshCards: SpacedRepetitionAlgorithm {
        
    /// Controls wether a random value should be added to the time intervals. If this option is turned on, it prevents that the same learning units are always "grouped" together.
    public let addFuzzyness: Bool
    
    public init(addFuzzyness: Bool = false) {
        self.addFuzzyness = addFuzzyness
    }
    
    public func nextInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        if (lastReview.isInLearningPhase) {
            return nextIntervalForLearningPhase(lastReview: lastReview, currentEvaluation: currentEvaluation)
        } else {
            return nextIntervalForReviewPhase(lastReview: lastReview, currentEvaluation: currentEvaluation, easeFactor: easeFactor)
        }
    }
    
    public func nextEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {
        if (lastReview.isInLearningPhase) {
            return lastReview.easeFactor // the ease factor is not changed during the learning phase
        }
            
        if (currentEvaluation.score.wasRecalled()) {
            if (currentEvaluation.lateness >= -0.10) {
                return nextEaseFactorForNonEarlyReview(lastReview: lastReview, currentEvaluation: currentEvaluation)
            } else {
                return nextEaseFactorForEarlyReview(lastReview: lastReview, currentEvaluation: currentEvaluation)
            }
        } else {
            // Reduce the ease factor (the information unit is harder than expected)
            return max(EaseFactors.veryDifficult, lastReview.easeFactor - 0.20)
        }
    }
    
    private func nextIntervalForLearningPhase(lastReview: Review, currentEvaluation: Evaluation) -> Double {
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
    
    private func nextIntervalForReviewPhase(lastReview: Review, currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        var interval: Double
        
        if (currentEvaluation.score.wasRecalled()) {
            if (currentEvaluation.lateness >= -0.10) {
                interval = nextIntervalForNonEarlyReview(lastReview: lastReview, currentEvaluation: currentEvaluation, easeFactor: easeFactor)
            } else {
                interval = nextIntervalForEarlyReview(lastReview: lastReview, currentEvaluation: currentEvaluation)
            }
            interval = addFuzz(originalValue: interval, fuzzFactor: 0.05)
        } else {
            // The learning unit was not recalled, therefore it should be repeated in a short period of time
            interval = numberOfDays(fromMinutes: 30)
        }
        return interval
    }
    
    private func nextIntervalForNonEarlyReview(lastReview: Review, currentEvaluation: Evaluation, easeFactor: Double) -> Double {
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
    
    
    private func nextIntervalForEarlyReview(lastReview: Review, currentEvaluation: Evaluation) -> Double {
        let futureWeight = futureWeight(currentEvaluation: currentEvaluation)
        let currentWeight = 1.0 - futureWeight
        let futureEasefactor = futureEaseFactor(lastReview: lastReview, currentEvaluation: currentEvaluation, futureWeight: futureWeight)

        var futureInterval: Double
            
        switch lastReview.numberOfCorrectReviewsInARow {
        case 0: futureInterval = 1
        case 1: futureInterval = 6
        default: futureInterval =  ceil(lastReview.intervalDays * futureEasefactor)
        }
        
        return  lastReview.intervalDays * currentWeight + futureInterval * futureWeight
    }
    
    private func addFuzz(originalValue: Double, fuzzFactor: Double) -> Double {
        if (addFuzzyness) {
            return originalValue * (1.0 + Double.random(in: 0..<1) * fuzzFactor)
        }
        return originalValue
    }
    
    private func futureWeight(currentEvaluation: Evaluation) -> Double {
        let normalizedEarliness = (1.0 + currentEvaluation.lateness)
        
        //put the value into a curved function:
        let futureWeight = min(exp(normalizedEarliness * normalizedEarliness) - 1.0, 1.0)
        return futureWeight
    }
    
    private func futureEaseFactor(lastReview: Review, currentEvaluation: Evaluation, futureWeight: Double) -> Double {
        let currentWeight = 1.0 - futureWeight

        // The score is extrapolated to the future. The algorithm predicts what the future score is likely to be (it assumes that the score will decrease since it is harder to recall "older" learning units)
        let predictedFutureScore = currentWeight * currentEvaluation.scoreValue + futureWeight * 3.0
        
        // the assumed future ease factor
        return max(EaseFactors.veryDifficult, lastReview.easeFactor + (0.1 - (5 - predictedFutureScore) * (0.08+(5 - predictedFutureScore)*0.02)))
        
    }
    
    private func nextEaseFactorForEarlyReview(lastReview: Review, currentEvaluation: Evaluation) -> Double {
        let futureWeight = futureWeight(currentEvaluation: currentEvaluation)
        let currentWeight = 1.0 - futureWeight
        let futureEasefactor = futureEaseFactor(lastReview: lastReview, currentEvaluation: currentEvaluation, futureWeight: futureWeight)
        return lastReview.easeFactor * currentWeight + futureEasefactor * futureWeight
    }
    
    private func nextEaseFactorForNonEarlyReview(lastReview: Review, currentEvaluation: Evaluation) -> Double {
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
    
    
    
}
