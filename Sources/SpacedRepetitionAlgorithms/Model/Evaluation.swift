/// The user's results from a review.
struct Evaluation {
    
    /// represents how well the learning unit was recalled (or not recalled)
    let score: Score
    
    var scoreValue: Double {
        return Double(score.rawValue)
    }
    
    /// how many days was the actual evaluation later (or earlier) than the proposed evaluation? Positive values mean that the review was done "too late". For example, a lateness of "1" means that the learning unit was reviewed one day later than expected. Negative values mean that the review was done "too early". For example, a lateness of "-1" means that the learning unit was reviewed one day sooner than expected.
    let lateness: Double
    
    init(score: Score, lateness: Double = 0) {
        self.score = score
        self.lateness = lateness
    }
}
