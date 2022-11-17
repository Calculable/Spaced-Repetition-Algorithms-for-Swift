import Foundation

class FreshCards: SpacedRepetitionAlgorithm {
        
    let addFuzzyness: Bool
    
    init(addFuzzyness: Bool = false) {
        self.addFuzzyness = addFuzzyness
    }
    
    fileprivate func nextReviewEaseFactorForEarlyReview(_ currentEvaluation: Evaluation, _ lastReview: Review) -> Double {
        // Card was reviewed "too early".
        
        // First, normalize the lateness factor into a range of 0.0 to 1.0 instead of -1.0 to 0.0
        // (which indicates how early the review is).
        let earliness = (1.0 + currentEvaluation.lateness)
        // min(e^(earlieness^2) - 1.0), 1.0) gives us a nice weighted curve. You can plot it on a
        // site like fooplot.com. As we get closer to the true deadline, the future is given more
        // weight.
        let futureWeight = min(exp(earliness * earliness) - 1.0, 1.0)
        let currentWeight = 1.0 - futureWeight
        
        // Next we take the score at this time and extrapolate what that score may be in the
        // future, using the weighting function. Essentially, if you reviewed 5.0 today, we will
        // decay that score down to a minimum of 3.0 in the future. Something easily remembered
        // now may not be easily remembered in the future.
        let predictedFutureScore = currentWeight * currentEvaluation.scoreValue + futureWeight * 3.0
        
        // Compute the future efactor and interval using the future score
        let futureEfactor = max(EaseFactors.veryDifficult, lastReview.easeFactor + (0.1 - (5 - predictedFutureScore) * (0.08+(5 - predictedFutureScore)*0.02)))
        
        
        // Finally, combine the previous and next efactor and intervals
        return lastReview.easeFactor * currentWeight + futureEfactor * futureWeight
    }
    
    fileprivate func nextReviewEaseFactorForNonEarlyReview(_ currentEvaluation: Evaluation, _ lastReview: Review) -> Double {
        // Review was not too early, so handle normally
        
        var latenessScoreBonus = 0.0
        
        // If this review was done late and user still got it right, give a slight bonus to the score of up to 1.0.
        // This means if a card was hard to remember AND it was late, the efactor should be unchanged. On the other
        // hand, if the card was easy, we should bump up the efactor by even more than normal.
        if (currentEvaluation.lateness >= 0.10 && currentEvaluation.score.wasRecalled()) {
            
            let latenessFactor = min(1.0, currentEvaluation.lateness)
            
            // Score factor can range from 1.0 to 1.5
            let scoreFactor = 1.0 + (currentEvaluation.scoreValue - 3.0) / 4.0
            
            
            // Bonus can range from 0.0 to 1.0.
            latenessScoreBonus = 1.0 * latenessFactor * scoreFactor
        }
        
        let adjustedScore = latenessScoreBonus + currentEvaluation.scoreValue
        return max(EaseFactors.veryDifficult, lastReview.easeFactor + (0.1 - (5 - adjustedScore) * (0.08+(5 - adjustedScore)*0.02)))
    }
    
    internal func nextReviewEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {
        if (lastReview.numberOfCorrectReviewsInARow < 3) {
            // Still in learning phase, so do not change efactor
            return lastReview.easeFactor
        }
            
        if (!currentEvaluation.score.wasRecalled()) {
            // Reduce efactor
            return max(EaseFactors.veryDifficult, lastReview.easeFactor - 0.20)
        } else {
                // Passed, so adjust efactor
                
                if (currentEvaluation.lateness >= -0.10) {
                    return nextReviewEaseFactorForNonEarlyReview(currentEvaluation, lastReview)
                
                } else {
                    return nextReviewEaseFactorForEarlyReview(currentEvaluation, lastReview)
                }
                
            }
    }
    
    
    fileprivate func nextReviewIntervalForLearningPhase(_ currentEvaluation: Evaluation, _ lastReview: Review) -> Double {
        var interval: Double
        
        if (!currentEvaluation.score.wasRecalled()) {
            interval = numberOfDays(fromMinutes: 30)
        } else {
            switch lastReview.numberOfCorrectReviewsInARow {
            case 0:
                interval = numberOfDays(fromMinutes: 30)
            case 1:
                interval = 0.5 //12h
            default:
                interval = 1 //24 hours
            }
        }
        
        interval = addFuzz(originalValue: interval, fuzzFactor: 0.1)
        return interval
    }
    
    fileprivate func nextReviewIntervalForNonEarlyReview(_ currentEvaluation: Evaluation, _ lastReview: Review, _ easeFactor: Double) -> Double {
        // Review was not too early, so handle normally
        
        var intervalAdjustment = 1.0
        
        if !(currentEvaluation.lateness >= 0.10 && currentEvaluation.scoreValue >= 3.0) {
            
            // Card wasn't late, so adjust differently
            
            if (currentEvaluation.score.wasRecalled() && currentEvaluation.scoreValue < 4) {
                // hard card, so adjust interval slightly
                intervalAdjustment = 0.8
            }
        }
        
        // Figure out interval. First review is in 1d, then 6d, then based on efactor and previous interval.
        if (lastReview.numberOfCorrectReviewsInARow == 0) {
            return 1
        } else if (lastReview.numberOfCorrectReviewsInARow  == 1) {
            return 6
        } else {
            return ceil(lastReview.intervalDays * intervalAdjustment * easeFactor)
        }
    }
    
    fileprivate func futureEFactor() {
        
    }
    
    fileprivate func nextReviewIntervalForEarlyReview(_ currentEvaluation: Evaluation, _ lastReview: Review) -> Double {
        
        var interval: Double
        
        // Card was reviewed "too early". Since Fresh Cards lets you review cards outside of the
        // SRS schedule, it takes a different approach to early reviews. It will not progress the SRS
        // schedule too quickly if you review early. If we didn't handle this case, what would happen
        // is if you review a card multiple times in the same day, it would progress the schedule and
        // might make the card due next in 30 days, which doesn't make sense. Just because you reviewed
        // it frequently doesn't mean you have committed to memory stronger. It still takes a few days
        // for it to sink it.
        
        // Therefore, what this section does is does a weighted average of the previous interval
        // with the interval in the future had you reviewed it on time instead of early. The weighting
        // function gives greater weight to the previous interval period if you review too early,
        // and as we approach the actual due date, we weight the next interval more. This ensures
        // we don't progress through the schedule too quickly if you review a card frequently.
        
        
        // Figure out the weight for the previous and next intervals.
        // First, normalize the lateness factor into a range of 0.0 to 1.0 instead of -1.0 to 0.0
        // (which indicates how early the review is).
        let earliness = (1.0 + currentEvaluation.lateness)
        // min(e^(earlieness^2) - 1.0), 1.0) gives us a nice weighted curve. You can plot it on a
        // site like fooplot.com. As we get closer to the true deadline, the future is given more
        // weight.
        let futureWeight = min(exp(earliness * earliness) - 1.0, 1.0)
        let currentWeight = 1.0 - futureWeight
        
        // Next we take the score at this time and extrapolate what that score may be in the
        // future, using the weighting function. Essentially, if you reviewed 5.0 today, we will
        // decay that score down to a minimum of 3.0 in the future. Something easily remembered
        // now may not be easily remembered in the future.
        let predictedFutureScore = currentWeight * currentEvaluation.scoreValue + futureWeight * 3.0
        
        // Compute the future efactor and interval using the future score
        let futureEfactor = max(EaseFactors.veryDifficult, lastReview.easeFactor + (0.1 - (5 - predictedFutureScore) * (0.08 + (5 - predictedFutureScore)*0.02)))
        
        
        var futureInterval: Double
        
        // Figure out interval. First review is in 1d, then 6d, then based on efactor and previous interval.
        
        switch lastReview.numberOfCorrectReviewsInARow {
        case 0: futureInterval = 1
        case 1: futureInterval = 6
        default: futureInterval =  ceil(lastReview.intervalDays * futureEfactor)
        }
        
        
        
        
        // Finally, combine the previous and next efactor and intervals
        interval = lastReview.intervalDays * currentWeight + futureInterval * futureWeight
        return interval
    }
    
    fileprivate func nextReviewIntervalForReviewPhase(_ currentEvaluation: Evaluation, _ lastReview: Review, _ easeFactor: Double) -> Double {
        var interval: Double
        // Reviewing phase
        
        if (!currentEvaluation.score.wasRecalled()) {
            // Failed, so force re-review in 30 minutes and reset n count
            interval = numberOfDays(fromMinutes: 30)
        } else {
            // Passed
            
            
            // First see if this was done close to on time or late. We handle early reviews differently
            // because Fresh Cards allows you to review cards as many times as you'd like, outside of
            // the SRS schedule. See details below in the "early" section.
            
            if (currentEvaluation.lateness >= -0.10) {
                interval = nextReviewIntervalForNonEarlyReview(currentEvaluation, lastReview, easeFactor)
            } else {
                
                interval = nextReviewIntervalForEarlyReview(currentEvaluation, lastReview)
            }
            
            
                // Add 5% "fuzz" to interval to avoid bunching up reviews
                interval = addFuzz(originalValue: interval, fuzzFactor: 0.05)
            
            
        }
        
        return interval
    }
    
    internal func nextReviewInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {

        
        
        
        if (lastReview.numberOfCorrectReviewsInARow < 3) {
            
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
