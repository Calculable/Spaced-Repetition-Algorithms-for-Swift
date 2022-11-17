import Foundation

///The Leitner System is a straightforward spaced repetition system from 1970. This system is often used with physical flashcards. The physical version requires several boxes to put the cards in. Cards in the first box are repeated every day, cards in the second box are repeated every 3 days, cards in the third box are repeated every 5 days and so on. If a card is recalled correctly during a review, it is promoted to the next box. If a card is not recalled during the review, it is moved back to the previous box. This algorithm rebuilds the leitner system in software. The intervals are configurable. The lateness of a review is not considered for this algorithm.
///Note: Currently, learning units stay in the last box "forever"
class LeitnerSystem: SpacedRepetitionAlgorithm {
    
    ///the intervals (in days) for the different "boxes".
    let intervals: [Double]
    
    init(intervals: [Double] = [ 1, 3, 5, 10, 30 ]) {
        self.intervals = intervals
    }

    
    internal func nextReviewEaseFactor(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Double {
        // the ease factor is irrelevant for this algorithm so it is just returned unchanged.
        return lastReview.easeFactor
    }
    
    
    internal func nextReviewInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        if !currentEvaluation.score.wasRecalled() {
            return 1
        }
        return intervals[min(lastReview.numberOfCorrectReviewsInARow, intervals.count-1)] //"move" the learning unit to the next "box"
    }
    
}
