import Foundation

// See https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
struct SM2: SpacedRepetitionAlgorithm {
    
    internal func nextReviewEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {
        let currentScore = currentEvaluation.scoreValue
        let calculatedEaseFactor: Double = lastReview.easeFactor + (0.1 - (5 - currentScore) * (0.08+(5 - currentScore)*0.02))
        return max(EaseFactors.veryDifficult, calculatedEaseFactor)
    }
    
    internal func nextReviewInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        if !currentEvaluation.score.wasRecalled() {
            return 1 //the information was not recalled today, therefore the information should be revewed on the next day
        }
        
        switch lastReview.numberOfCorrectReviewsInARow {
            case 0: return 1
            case 1: return 6
            default: return ceil(Double(lastReview.intervalDays) * easeFactor)
        }
    }
    
}
