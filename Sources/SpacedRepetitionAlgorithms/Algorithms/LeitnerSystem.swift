import Foundation

/// https://en.wikipedia.org/wiki/Leitner_system
/// Note: unlike a real system which reviews cards in each "box" when it becomes
/// full, this just causes all cards to follow the 'ladder up' schedule above.
/// On a failure, we start again from the top of the list.
struct LeitnerSystem: SpacedRepetitionAlgorithm {
    
    let intervals: [Double] = [ 1, 3, 5, 10, 30 ]
    
    internal func nextReviewEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {
            // We don't care what efactor is, so just carry it forward
            return lastReview.easeFactor
    }
    
    
    internal func nextReviewInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        if !currentEvaluation.score.wasRecalled() {
            return 1 //the information was not recalled today, therefore the information should be revewed on the next day
        }
        return intervals[min(lastReview.numberOfCorrectReviewsInARow, intervals.count-1)]
    }
    
}
