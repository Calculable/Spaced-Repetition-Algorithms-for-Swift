import Foundation

/// This algorithm always uses the same interval. The ease factor or the evaluation score is not considered.
class DueRegularly: SpacedRepetitionAlgorithm {
    
    /// The interval to use constantly
    let dueInterval: Double
    
    init(dueInterval: Double = 1) {
        self.dueInterval = dueInterval
    }
    
    internal func nextReviewEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {
        //This algorithm does not care about the ease factor so its just passed unchanged
        return lastReview.easeFactor
    }
    
    internal func nextReviewInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        return dueInterval
    }
    
}
