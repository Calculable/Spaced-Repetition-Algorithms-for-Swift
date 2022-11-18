///Spaced repetition algorithms are often used in flashcard apps. The algorithms calculate how long the optimal time interval between two reviews for a learning unit should be. The calculation is based on the user's feedback on how easy or difficult the last review was perceived. Normally, the time interval increases the more often a learning unit has been successfully recalled. Frequent repetitions cause the memory curve to decrease slower. If a learning content cannot be recalled, the time intervals between reviews will become shorter again.
public protocol SpacedRepetitionAlgorithm {
    
    /// Calculates when the next review should be for a learning unit
    /// - Parameters:
    ///   - lastReview: The previous review for the same learning unit. Use the output of this method  for the input of the next call. The new interval is based on the previous interval. If a learning unit is successfully recalled multiple times in a row, the new intervals until the next review will get longer.
    ///   - currentEvaluation: The evaluation for the same learning unit. Contains the information how well the information was recalled. If the learning unit was recalled easily, the new interval until the next learning unit will be longer. If the learning unit was not recalled successfully, the interval will be shorter.
    /// - Returns: The review contains the time interval in days (= how long should a user wait to review the same learning unit again). The review-instance also contains an internal ease factor which describes the assumed "difficulty" of a learning unit. This information is used when the review will be passed again to this method. Time intervals for difficult learning units will be shorter.
    func nextReview(lastReview: Review, currentEvaluation: Evaluation) -> Review
    
    /// Calculates the new ease factor of a learning unit based on the user's latest ealuation. The ease factor describes how "easy" or "difficult" the algorithm assumes a learning unit to be.
    /// - Parameters:
    ///   - lastReview: The previous review for a learning unit.
    ///   - currentEvaluation: The evaluation for the same learning unit.
    /// - Returns: The new ease factor. The heigher the ease factor, the "easier" a learning unit is assumed to be.
    func nextEaseFactor(lastReview: Review, currentEvaluation: Evaluation) -> Double
    
    /// Calculates the new review interval (in days) for a learning unit based on the user's latest ealuation.
    /// - Parameters:
    ///   - lastReview: The previous review for a learning unit.
    ///   - currentEvaluation: The evaluation for the same learning unit.
    /// - Returns: next review interval in days. The result is not always a full day, for example, 0.5 means "12 hours". This value indicates the time duration the algorithm succests until the user should review the same learning unit again.
    func nextInterval(lastReview: Review, currentEvaluation: Evaluation, easeFactor: Double) -> Double
    
    /// Calculates the amount of "correct" reviews in a row. "Correct" means that the information was recalled (score >= 3) during an evaluation. If the learning unit is not recalled during a review, this value is reset to 0.
    /// - Parameters:
    ///   - lastReview: The previous review for a learning unit.
    ///   - currentEvaluation: The evaluation for the same learning unit.
    /// - Returns: The amount of times in a row where the learning unit was "recalled".
    func nextNumberOfCorrectReviewsInARow(lastReview: Review, currentEvaluation: Evaluation) -> Int
}
