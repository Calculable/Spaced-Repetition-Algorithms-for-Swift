import Foundation

///This is one of the most well-known spaced repetition algorithms. The lateness of a review is not considered for this algorithm.
/// See https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
public class SM2: SpacedRepetitionAlgorithm {
    
    public func nextEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {
        let calculatedEaseFactor: Double = lastReview.easeFactor + (0.1 - (5 - currentEvaluation.scoreValue) * (0.08+(5 - currentEvaluation.scoreValue)*0.02))
        return max(EaseFactors.veryDifficult, calculatedEaseFactor)
    }
    
    public func nextInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        if !currentEvaluation.score.wasRecalled() {
            return 1 //review again on the next day
        }
        
        switch lastReview.numberOfCorrectReviewsInARow {
        case 0: return 1
        case 1: return 6
        default: return ceil(Double(lastReview.intervalDays) * easeFactor)
        }
    }
    
}
