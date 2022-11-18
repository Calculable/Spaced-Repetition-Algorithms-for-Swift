import Foundation

/// This algorithm always uses the same interval. The ease factor or the evaluation score is not considered.
public class DueRegularly: SpacedRepetitionAlgorithm {
    
    /// The interval to use constantly
    public let dueInterval: Double
    
    public init(dueInterval: Double = 1) {
        self.dueInterval = dueInterval
    }
    
    public func nextEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {
        //This algorithm does not care about the ease factor so its just passed unchanged
        return lastReview.easeFactor
    }
    
    public func nextInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        return dueInterval
    }
    
}
