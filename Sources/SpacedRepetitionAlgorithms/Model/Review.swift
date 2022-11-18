/// Contains information about the next proposed review. The main information is the day-interval (= a succestion when the next review session should be).
public struct Review {
    
    /// days since the last review or until the next review
    public let intervalDays: Double
    
    /// how many reviews in a row was the information recalled successfully
    public let numberOfCorrectReviewsInARow: Int
    
    /// stores the difficulty to recall a learning unit. See struct EaseFactors for example values. Usually between 1.3 (very difficult to recall) and 2.5 (very easy to recall)
    public let easeFactor: Double
    
    
    /// A learning unit is considered to be in the "learning" phase if the information unit was not successfully recalled for three times in a row lately
    var isInLearningPhase: Bool {
        numberOfCorrectReviewsInARow <= 2
    }
    
    /// A learning unit is considered to be in the "reviewing" phase if the information unit was  successfully recalled for three or more times in a row lately
    var isInReviewingPhase: Bool {
        !isInLearningPhase
    }
    
    public init(intervalDays: Double, numberOfCorrectReviewsInARow: Int, easeFactor: Double) {
        self.intervalDays = intervalDays
        self.numberOfCorrectReviewsInARow = numberOfCorrectReviewsInARow
        self.easeFactor = easeFactor
    }
    
    public init() {
        self.init(intervalDays: 0.0, numberOfCorrectReviewsInARow: 0, easeFactor: EaseFactors.defaultEaseFactor)
    }
}
