import Foundation

// This is the simplest example of an SRS algorithm: An interval of 1.0 is used
// to indicate that the card is due 1 day after the current review, regardless
// of evaluation.score value.
struct DueRegularly: SpacedRepetitionAlgorithm {
    
    let dueInterval: Double
    
    init(dueInterval: Double = 1) {
        self.dueInterval = dueInterval
    }
    
    internal func nextReviewEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {
        return EaseFactors.defaultEaseFactor
    }
    
    internal func nextReviewInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        return dueInterval
    }
    
}
