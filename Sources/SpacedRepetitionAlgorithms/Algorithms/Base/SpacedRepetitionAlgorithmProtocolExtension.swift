extension SpacedRepetitionAlgorithm {
        
    func nextReview(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Review {
        let nextEaseFactor = nextReviewEaseFactor(lastReview: lastReview, currentEvaluation: currentEvaluation)
        let newInterval = nextReviewInterval(lastReview: lastReview, currentEvaluation: currentEvaluation, easeFactor: nextEaseFactor)
        let newNumberOfCorrectReviewsInARow = nextReviewNumberOfCorrectReviewsInARow(lastReview: lastReview, currentEvaluation: currentEvaluation)
        return Review(intervalDays: newInterval, numberOfCorrectReviewsInARow: newNumberOfCorrectReviewsInARow, easeFactor: nextEaseFactor)
    }
    
    
    internal func nextReviewNumberOfCorrectReviewsInARow(lastReview: Review = Review(), currentEvaluation: Evaluation) -> Int {
        if currentEvaluation.score.wasRecalled() {
            return lastReview.numberOfCorrectReviewsInARow + 1
        } else {
            return 0
        }
    }

}
