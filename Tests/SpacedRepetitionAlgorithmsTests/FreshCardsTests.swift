
import XCTest
@testable import SpacedRepetitionAlgorithms

final class FreshCardsTests: XCTestCase {
    
    var subject: FreshCards!
    
    override func setUp() {
        subject = FreshCards(addFuzzyness: false) //don't use randomness for testing
    }
    
    override func tearDown() {
        subject = nil
    }
    
    func testTypicalSchedule() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.020833333333333332, accuracy: 0.000000001)
        
        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.5, accuracy: 0.000000001)
        
        let evaluation3 = Evaluation(score: Score.recalled_easily)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.000000001)
        
        let evaluation4 = Evaluation(score: Score.recalled_but_difficult)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.36, accuracy: 0.000000001)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 2.0, accuracy: 0.000000001)
        
        let evaluation5 = Evaluation(score: Score.recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.36, accuracy: 0.000000001)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 5.0, accuracy: 0.000000001)
        
        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.22, accuracy: 0.000000001)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 9.0, accuracy: 0.000000001)
        
        let evaluation7 = Evaluation(score: Score.recalled)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.22, accuracy: 0.000000001)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 20.0, accuracy: 0.000000001)
        
        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.22, accuracy: 0.000000001)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 45.0, accuracy: 0.000000001)
        
        let evaluation9 = Evaluation(score: Score.recalled_but_difficult)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 2.08, accuracy: 0.000000001)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 9)
        XCTAssertEqual(review9.intervalDays, 75.0, accuracy: 0.000000001)
        
        let evaluation10 = Evaluation(score: Score.recalled)
        let review10 = subject.nextReview(lastReview: review9, currentEvaluation: evaluation10)
        XCTAssertEqual(review10.easeFactor, 2.08, accuracy: 0.000000001)
        XCTAssertEqual(review10.numberOfCorrectReviewsInARow, 10)
        XCTAssertEqual(review10.intervalDays, 156.0, accuracy: 0.000000001)
        
        let evaluation11 = Evaluation(score: Score.recalled_but_difficult)
        let review11 = subject.nextReview(lastReview: review10, currentEvaluation: evaluation11)
        XCTAssertEqual(review11.easeFactor, 1.94, accuracy: 0.000000001)
        XCTAssertEqual(review11.numberOfCorrectReviewsInARow, 11)
        XCTAssertEqual(review11.intervalDays, 243, accuracy: 0.000000001)
    }
    
    func testScheduleWithEventualLapses() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.020833333333333332, accuracy: 0.000000001)
        
        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.5, accuracy: 0.000000001)
        
        let evaluation3 = Evaluation(score: Score.recalled_easily)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.000000001)
        
        let evaluation4 = Evaluation(score: Score.recalled)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 3.0, accuracy: 0.000000001)
        
        let evaluation5 = Evaluation(score: Score.recalled_but_difficult)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.36, accuracy: 0.000000001)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 6.0, accuracy: 0.000000001)
        
        let evaluation6 = Evaluation(score: Score.not_recalled)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.16, accuracy: 0.000000001)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review6.intervalDays, 0.020833333333333332, accuracy: 0.000000001)
        
        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.16, accuracy: 0.000000001)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review7.intervalDays, 0.020833333333333332, accuracy: 0.000000001)
        
        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.16, accuracy: 0.000000001)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review8.intervalDays, 0.5, accuracy: 0.000000001)
        
        let evaluation9 = Evaluation(score: Score.recalled)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 2.16, accuracy: 0.000000001)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review9.intervalDays, 1.0, accuracy: 0.000000001)
    }
    
    func testScheduleWhereReviewsAreInitiallyHard() {
        let evaluation1 = Evaluation(score: Score.not_recalled_and_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review1.intervalDays, 0.020833333333333332, accuracy: 0.000000001)
        
        let evaluation2 = Evaluation(score: Score.recalled_but_difficult)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review2.intervalDays, 0.020833333333333332, accuracy: 0.000000001)
        
        let evaluation3 = Evaluation(score: Score.not_recalled)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review3.intervalDays, 0.020833333333333332, accuracy: 0.000000001)
        
        let evaluation4 = Evaluation(score: Score.recalled_but_difficult)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review4.intervalDays, 0.020833333333333332, accuracy: 0.000000001)
        
        let evaluation5 = Evaluation(score: Score.not_recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review5.intervalDays, 0.020833333333333332, accuracy: 0.000000001)
        
        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review6.intervalDays, 0.020833333333333332, accuracy: 0.000000001)
        
        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review7.intervalDays, 0.5, accuracy: 0.000000001)
        
        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.5, accuracy: 0.000000001)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review8.intervalDays, 1.0, accuracy: 0.000000001)
        
        let evaluation9 = Evaluation(score: Score.recalled_but_difficult)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 2.36, accuracy: 0.000000001)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review9.intervalDays, 2.0, accuracy: 0.000000001)
        
        let evaluation10 = Evaluation(score: Score.recalled_but_difficult)
        let review10 = subject.nextReview(lastReview: review9, currentEvaluation: evaluation10)
        XCTAssertEqual(review10.easeFactor, 2.22, accuracy: 0.000000001)
        XCTAssertEqual(review10.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review10.intervalDays, 4.0, accuracy: 0.000000001)
    }
    
    func testScheduleWhereCardsAreReviewedLateButGotItRight() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.5, accuracy: 0.01)
        
        let evaluation3 = Evaluation(score: Score.recalled_easily)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.01)
        
        let evaluation4 = Evaluation(score: Score.recalled_but_difficult, lateness: 0.5)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.44, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 3.0, accuracy: 0.01)
        
        let evaluation5 = Evaluation(score: Score.recalled, lateness: 2.0)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.55, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 8.0, accuracy: 0.01)
        
        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.41, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 16.0, accuracy: 0.01)
        
        let evaluation7 = Evaluation(score: Score.recalled, lateness: 2.0)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.53, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 41.0, accuracy: 0.01)
        
        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.53, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 104.0, accuracy: 0.01)
        
        let evaluation9 = Evaluation(score: Score.recalled_but_difficult)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 2.39, accuracy: 0.005)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 9)
        XCTAssertEqual(review9.intervalDays, 200, accuracy: 0.01)
        
        let evaluation10 = Evaluation(score: Score.recalled)
        let review10 = subject.nextReview(lastReview: review9, currentEvaluation: evaluation10)
        XCTAssertEqual(review10.easeFactor, 2.39, accuracy: 0.005)
        XCTAssertEqual(review10.numberOfCorrectReviewsInARow, 10)
        XCTAssertEqual(review10.intervalDays, 479.0, accuracy: 0.01)
        
        let evaluation11 = Evaluation(score: Score.recalled_but_difficult)
        let review11 = subject.nextReview(lastReview: review10, currentEvaluation: evaluation11)
        XCTAssertEqual(review11.easeFactor, 2.25, accuracy: 0.005)
        XCTAssertEqual(review11.numberOfCorrectReviewsInARow, 11)
        XCTAssertEqual(review11.intervalDays, 864.0, accuracy: 0.01)
    }
    
    func testScheduleWhereCardsAreReviewedTooEarly() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.5, accuracy: 0.01)
        
        let evaluation3 = Evaluation(score: Score.recalled_but_difficult, lateness: -0.5)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.01)
        
        let evaluation4 = Evaluation(score: Score.recalled, lateness: -0.2916666667)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.44, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 2.3, accuracy: 0.01)
        
        let evaluation5 = Evaluation(score: Score.recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.44, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 6.0, accuracy: 0.01)
        
        let evaluation6 = Evaluation(score: Score.recalled, lateness: -2.0)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.30, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 14.0, accuracy: 0.01)
        
        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.16, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 25.0, accuracy: 0.01)
    }
    
    func testScheduleWhereInitialReviewsAreDoneLate() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation2 = Evaluation(score: Score.recalled_but_difficult, lateness: 0.01111111111)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.5, accuracy: 0.01)
        
        let evaluation3 = Evaluation(score: Score.recalled_but_difficult, lateness: 0.25)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.01)
        
        let evaluation4 = Evaluation(score: Score.recalled, lateness: 0.25)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.54, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 3.0, accuracy: 0.01)
        
        let evaluation5 = Evaluation(score: Score.recalled_but_difficult)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.4, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 6.0, accuracy: 0.01)
        
        let evaluation6 = Evaluation(score: Score.recalled)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.4, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 15.0, accuracy: 0.01)
        
        let evaluation7 = Evaluation(score: Score.recalled)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.4, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 36.0, accuracy: 0.01)
        
        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.4, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 87.0, accuracy: 0.01)
    }
    
    func testScheduleWhereCardIsConsistentlyHard() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation2 = Evaluation(score: Score.recalled_but_difficult)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.5, accuracy: 0.01)
        
        let evaluation3 = Evaluation(score: Score.recalled_but_difficult)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.01)
        
        let evaluation4 = Evaluation(score: Score.recalled_but_difficult)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 2.0, accuracy: 0.01)
        
        let evaluation5 = Evaluation(score: Score.recalled_but_difficult)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.22, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 4.0, accuracy: 0.01)
        
        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.08, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 7.0, accuracy: 0.01)
        
        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 1.94, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 11.0, accuracy: 0.01)
        
        let evaluation8 = Evaluation(score: Score.recalled_but_difficult)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 1.8, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 16.0, accuracy: 0.01)
    }
    
    func testScheduleWhereCardIsConsistentlyReviewedOkay() {
        let evaluation1 = Evaluation(score: Score.recalled)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.5, accuracy: 0.01)
        
        let evaluation3 = Evaluation(score: Score.recalled)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.01)
        
        let evaluation4 = Evaluation(score: Score.recalled)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 3.0, accuracy: 0.01)
        
        let evaluation5 = Evaluation(score: Score.recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 8.0, accuracy: 0.01)
        
        let evaluation6 = Evaluation(score: Score.recalled)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 20.0, accuracy: 0.01)
        
        let evaluation7 = Evaluation(score: Score.recalled)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 50.0, accuracy: 0.01)
        
        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 125.0, accuracy: 0.01)
    }
    
    func testScheduleWhereCardIsConsistentlyFailed() {
        let evaluation1 = Evaluation(score: Score.not_recalled)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review1.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation2 = Evaluation(score: Score.not_recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review2.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation3 = Evaluation(score: Score.not_recalled)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review3.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation4 = Evaluation(score: Score.not_recalled)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review4.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation5 = Evaluation(score: Score.not_recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review5.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation6 = Evaluation(score: Score.not_recalled)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review6.intervalDays, 0.020833333333333332, accuracy: 0.01)
    }
    
    func testScheduleWhereCardIsReviewedVeryEarly() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.020833333333333332, accuracy: 0.01)
        
        let evaluation2 = Evaluation(score: Score.recalled_but_difficult, lateness: -0.02291666667)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.5, accuracy: 0.01)
        
        let evaluation3 = Evaluation(score: Score.recalled_but_difficult, lateness: -0.5)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.01)
        
        let evaluation4 = Evaluation(score: Score.recalled_but_difficult, lateness: -0.9583333333333334)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 1.0, accuracy: 0.01)
        
        let evaluation5 = Evaluation(score: Score.recalled_but_difficult, lateness: -1.0)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 1.0, accuracy: 0.01)
        
        let evaluation6 = Evaluation(score: Score.recalled_but_difficult, lateness: -0.8333333333333334)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.50, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 1.06, accuracy: 0.01)
        
        let evaluation7 = Evaluation(score: Score.recalled_but_difficult, lateness: -0.9166666666666666)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.49, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 1.07, accuracy: 0.01)
        
        let evaluation8 = Evaluation(score: Score.recalled_but_difficult)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.35, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 3.0, accuracy: 0.01)
        
        let evaluation9 = Evaluation(score: Score.recalled_but_difficult, lateness: -2.0)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 2.21, accuracy: 0.005)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 9)
        XCTAssertEqual(review9.intervalDays, 7.0, accuracy: 0.01)
        
        let evaluation10 = Evaluation(score: Score.recalled_but_difficult, lateness: -2.0)
        let review10 = subject.nextReview(lastReview: review9, currentEvaluation: evaluation10)
        XCTAssertEqual(review10.easeFactor, 2.07, accuracy: 0.005)
        XCTAssertEqual(review10.numberOfCorrectReviewsInARow, 10)
        XCTAssertEqual(review10.intervalDays, 15.0, accuracy: 0.01)
        
        let evaluation11 = Evaluation(score: Score.recalled_but_difficult, lateness: -3.0)
        let review11 = subject.nextReview(lastReview: review10, currentEvaluation: evaluation11)
        XCTAssertEqual(review11.easeFactor, 1.93, accuracy: 0.005)
        XCTAssertEqual(review11.numberOfCorrectReviewsInARow, 11)
        XCTAssertEqual(review11.intervalDays, 30.0, accuracy: 0.01)
        
        let evaluation12 = Evaluation(score: Score.recalled_but_difficult, lateness: -4.0)
        let review12 = subject.nextReview(lastReview: review11, currentEvaluation: evaluation12)
        XCTAssertEqual(review12.easeFactor, 1.79, accuracy: 0.005)
        XCTAssertEqual(review12.numberOfCorrectReviewsInARow, 12)
        XCTAssertEqual(review12.intervalDays, 54.0, accuracy: 0.01)
    }
}
