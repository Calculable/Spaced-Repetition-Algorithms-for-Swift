/// the user's results from a review.
struct Evaluation {
    
    /// how well was the information recalled?
    let score: Score
    
    /// how many days was the actual evaluation later than the proposed evaluation?
    let lateness: Double
    
    init(score: Score, lateness: Double = 0) {
        self.score = score
        self.lateness = lateness
    }
}
