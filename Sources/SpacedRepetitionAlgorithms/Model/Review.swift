struct Review {
    
    /// days since the last review or until the next review
    let intervalDays: Double
    
    /// how many reviews in a row was the information recalled?
    let numberOfCorrectReviewsInARow: Int
    
    /// stores the difficulty to recall an information. See struct EaseFactors for example values. Usually between 1.3 (very difficult to recall) and 2.5 (very easy to recall)
    let easeFactor: Double
    
    init(intervalDays: Double, numberOfCorrectReviewsInARow: Int, easeFactor: Double) {
        self.intervalDays = intervalDays
        self.numberOfCorrectReviewsInARow = numberOfCorrectReviewsInARow
        self.easeFactor = easeFactor
    }
    
    init() {
        self.init(intervalDays: 0.0, numberOfCorrectReviewsInARow: 0, easeFactor: EaseFactors.defaultEaseFactor)
    }
}
