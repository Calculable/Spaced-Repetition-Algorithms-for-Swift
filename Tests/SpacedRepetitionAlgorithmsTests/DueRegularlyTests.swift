import XCTest
@testable import SpacedRepetitionAlgorithms

final class DueRegularlyTests: XCTestCase {
    
    var subject: DueRegularly!
    
    override func setUp() {
        subject = DueRegularly(dueInterval: 1)
    }
    
    override func tearDown() {
        subject = nil
    }
    
    func testScheduleWithEventualLapses() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation3 = Evaluation(score: Score.recalled_easily)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation4 = Evaluation(score: Score.recalled)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation5 = Evaluation(score: Score.recalled_but_difficult)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation6 = Evaluation(score: Score.not_recalled)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review6.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review7.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review8.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation9 = Evaluation(score: Score.recalled)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review9.intervalDays, 1, accuracy: 0.000000001)
    }
    
}
