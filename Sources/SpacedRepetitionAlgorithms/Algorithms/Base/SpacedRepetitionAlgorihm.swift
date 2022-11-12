protocol SpacedRepetitionAlgorithm {
    func nextReview(lastReview: Review, currentEvaluation: Evaluation) -> Review
    func nextReviewEaseFactor(lastReview: Review, currentEvaluation: Evaluation) -> Double
    func nextReviewInterval(lastReview: Review, currentEvaluation: Evaluation, easeFactor: Double) -> Double
    func nextReviewNumberOfCorrectReviewsInARow(lastReview: Review, currentEvaluation: Evaluation) -> Int
}
