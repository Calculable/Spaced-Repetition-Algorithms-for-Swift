
import XCTest
@testable import SpacedRepetitionAlgorithms

final class SM2Tests: XCTestCase {
    
    var subject: SM2!
    
    override func setUp() {
        subject = SM2()
    }
    
    override func tearDown() {
        subject = nil
    }
    
    func testTypicalSchedule() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        
        XCTAssertEqual(review1.easeFactor, 2.36, accuracy: 0.000000001)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        
        XCTAssertEqual(review2.easeFactor, 2.36, accuracy: 0.000000001)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 6, accuracy: 0.000000001)
        
        let evaluation3 = Evaluation(score: Score.recalled_easily)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        
        XCTAssertEqual(review3.easeFactor, 2.46, accuracy: 0.000000001)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 15, accuracy: 0.000000001)
        
        let evaluation4 = Evaluation(score: Score.recalled_but_difficult)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        
        XCTAssertEqual(review4.easeFactor, 2.32, accuracy: 0.000000001)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 35, accuracy: 0.000000001)
        
        let evaluation5 = Evaluation(score: Score.recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        
        XCTAssertEqual(review5.easeFactor, 2.32, accuracy: 0.000000001)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 82, accuracy: 0.000000001)
        
        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        
        XCTAssertEqual(review6.easeFactor, 2.18, accuracy: 0.000000001)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 179, accuracy: 0.000000001)
        
        let evaluation7 = Evaluation(score: Score.recalled)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        
        XCTAssertEqual(review7.easeFactor, 2.18, accuracy: 0.000000001)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 391, accuracy: 0.000000001)
        
        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        
        XCTAssertEqual(review8.easeFactor, 2.18, accuracy: 0.000000001)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 853, accuracy: 0.000000001)
        
        let evaluation9 = Evaluation(score: Score.recalled_but_difficult)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        
        XCTAssertEqual(review9.easeFactor, 2.04, accuracy: 0.000000001)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 9)
        XCTAssertEqual(review9.intervalDays, 1741, accuracy: 0.000000001)
        
        let evaluation10 = Evaluation(score: Score.recalled)
        let review10 = subject.nextReview(lastReview: review9, currentEvaluation: evaluation10)
        
        XCTAssertEqual(review10.easeFactor, 2.04, accuracy: 0.000000001)
        XCTAssertEqual(review10.numberOfCorrectReviewsInARow, 10)
        XCTAssertEqual(review10.intervalDays, 3552, accuracy: 0.000000001)
        
        let evaluation11 = Evaluation(score: Score.recalled_but_difficult)
        let review11 = subject.nextReview(lastReview: review10, currentEvaluation: evaluation11)
        
        XCTAssertEqual(review11.easeFactor, 1.90, accuracy: 0.000000001)
        XCTAssertEqual(review11.numberOfCorrectReviewsInARow, 11)
        XCTAssertEqual(review11.intervalDays, 6749, accuracy: 0.000000001)
    }
    
    func testScheduleWithEventualLapses() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        
        XCTAssertEqual(review1.easeFactor, 2.36, accuracy: 0.000000001)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        
        XCTAssertEqual(review2.easeFactor, 2.36, accuracy: 0.000000001)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 6, accuracy: 0.000000001)
        
        let evaluation3 = Evaluation(score: Score.recalled_easily)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        
        XCTAssertEqual(review3.easeFactor, 2.46, accuracy: 0.000000001)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 15, accuracy: 0.000000001)
        
        let evaluation4 = Evaluation(score: Score.recalled)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        
        XCTAssertEqual(review4.easeFactor, 2.46, accuracy: 0.000000001)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 37, accuracy: 0.000000001)
        
        let evaluation5 = Evaluation(score: Score.recalled_but_difficult)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        
        XCTAssertEqual(review5.easeFactor, 2.32, accuracy: 0.000000001)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 86, accuracy: 0.000000001)
        
        let evaluation6 = Evaluation(score: Score.not_recalled)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        
        XCTAssertEqual(review6.easeFactor, 2.00, accuracy: 0.000000001)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review6.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        
        XCTAssertEqual(review7.easeFactor, 1.86, accuracy: 0.000000001)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review7.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        
        XCTAssertEqual(review8.easeFactor, 1.86, accuracy: 0.000000001)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review8.intervalDays, 6, accuracy: 0.000000001)
        
        let evaluation9 = Evaluation(score: Score.recalled)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        
        XCTAssertEqual(review9.easeFactor, 1.86, accuracy: 0.000000001)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review9.intervalDays, 12, accuracy: 0.000000001)
    }
    
    func testScheduleWhereReviewsAreInitiallyHard() {
        let evaluation1 = Evaluation(score: Score.not_recalled_and_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 1.96, accuracy: 0.000000001)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review1.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation2 = Evaluation(score: Score.recalled_but_difficult)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 1.82, accuracy: 0.000000001)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review2.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation3 = Evaluation(score: Score.not_recalled)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 1.5, accuracy: 0.000000001)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review3.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation4 = Evaluation(score: Score.recalled_but_difficult)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 1.36, accuracy: 0.000000001)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review4.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation5 = Evaluation(score: Score.not_recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 1.3, accuracy: 0.000000001)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review5.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 1.3, accuracy: 0.000000001)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review6.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 1.3, accuracy: 0.000000001)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review7.intervalDays, 6, accuracy: 0.000000001)
        
        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 1.3, accuracy: 0.000000001)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review8.intervalDays, 8, accuracy: 0.000000001)
        
        let evaluation9 = Evaluation(score: Score.recalled_but_difficult)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 1.3, accuracy: 0.000000001)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review9.intervalDays, 11, accuracy: 0.000000001)
        
        let evaluation10 = Evaluation(score: Score.recalled_but_difficult)
        let review10 = subject.nextReview(lastReview: review9, currentEvaluation: evaluation10)
        XCTAssertEqual(review10.easeFactor, 1.3, accuracy: 0.000000001)
        XCTAssertEqual(review10.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review10.intervalDays, 15, accuracy: 0.000000001)
    }
    
    func testScheduleWhereCardIsConsistentlyHard() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.36, accuracy: 0.000000001)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation2 = Evaluation(score: Score.recalled_but_difficult)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.22, accuracy: 0.000000001)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 6, accuracy: 0.000000001)
        
        let evaluation3 = Evaluation(score: Score.recalled_but_difficult)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.08, accuracy: 0.000000001)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 13, accuracy: 0.000000001)
        
        let evaluation4 = Evaluation(score: Score.recalled_but_difficult)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 1.94, accuracy: 0.000000001)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 26, accuracy: 0.000000001)
        
        let evaluation5 = Evaluation(score: Score.recalled_but_difficult)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 1.8, accuracy: 0.000000001)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 47, accuracy: 0.000000001)
        
        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 1.66, accuracy: 0.000000001)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 79, accuracy: 0.000000001)
        
        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 1.52, accuracy: 0.000000001)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 121, accuracy: 0.000000001)
        
        let evaluation8 = Evaluation(score: Score.recalled_but_difficult)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 1.38, accuracy: 0.000000001)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 167, accuracy: 0.000000001)
    }
    
    func testScheduleWhereCardIsConsistentlyFailed() {
        let evaluation1 = Evaluation(score: Score.not_recalled)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.18, accuracy: 0.000000001)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review1.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation2 = Evaluation(score: Score.not_recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 1.86, accuracy: 0.000000001)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review2.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation3 = Evaluation(score: Score.not_recalled)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 1.54, accuracy: 0.000000001)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review3.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation4 = Evaluation(score: Score.not_recalled)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 1.3, accuracy: 0.000000001)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review4.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation5 = Evaluation(score: Score.not_recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 1.3, accuracy: 0.000000001)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review5.intervalDays, 1, accuracy: 0.000000001)
        
        let evaluation6 = Evaluation(score: Score.not_recalled)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 1.3, accuracy: 0.000000001)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review6.intervalDays, 1, accuracy: 0.000000001)
    }
}
