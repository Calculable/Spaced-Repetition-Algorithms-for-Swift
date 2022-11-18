/// Provides default implementations for the SpacedRepetitionAlgorithm protocol
extension SpacedRepetitionAlgorithm {
        
    func nextReview(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Review {
        let nextEaseFactor = nextEaseFactor(lastReview: lastReview, currentEvaluation: currentEvaluation)
        let newInterval = nextInterval(lastReview: lastReview, currentEvaluation: currentEvaluation, easeFactor: nextEaseFactor)
        let newNumberOfCorrectReviewsInARow = nextNumberOfCorrectReviewsInARow(lastReview: lastReview, currentEvaluation: currentEvaluation)
        return Review(intervalDays: newInterval, numberOfCorrectReviewsInARow: newNumberOfCorrectReviewsInARow, easeFactor: nextEaseFactor)
    }
    
    internal func nextNumberOfCorrectReviewsInARow(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Int {
        if currentEvaluation.score.wasRecalled() {
            return lastReview.numberOfCorrectReviewsInARow + 1
        }
        return 0
    }
}
