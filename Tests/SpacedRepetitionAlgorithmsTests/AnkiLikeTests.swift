
import XCTest
@testable import SpacedRepetitionAlgorithms

final class AnkiLikeTests: XCTestCase {
    
    var subject: AnkiLikeAlgorithm!
    
    override func setUp() {
        subject = AnkiLikeAlgorithm(addFuzzyness: false) //don't use randomness for testing
    }
    
    override func tearDown() {
        subject = nil
    }
    
    func testTypicalSchedule() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.006944444444444444, accuracy: 0.01)

        let evaluation3 = Evaluation(score: Score.recalled_easily)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 4.0, accuracy: 0.01)

        let evaluation4 = Evaluation(score: Score.recalled_but_difficult)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 5, accuracy: 0.01)

        let evaluation5 = Evaluation(score: Score.recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 12, accuracy: 0.01)

        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.22, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 15, accuracy: 0.01)

        let evaluation7 = Evaluation(score: Score.recalled)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.22, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 34, accuracy: 0.01)

        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.22, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 76, accuracy: 0.01)

        let evaluation9 = Evaluation(score: Score.recalled_but_difficult)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 2.08, accuracy: 0.005)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 9)
        XCTAssertEqual(review9.intervalDays, 92, accuracy: 0.01)

        let evaluation10 = Evaluation(score: Score.recalled)
        let review10 = subject.nextReview(lastReview: review9, currentEvaluation: evaluation10)
        XCTAssertEqual(review10.easeFactor, 2.08, accuracy: 0.005)
        XCTAssertEqual(review10.numberOfCorrectReviewsInARow, 10)
        XCTAssertEqual(review10.intervalDays, 192, accuracy: 0.01)

        let evaluation11 = Evaluation(score: Score.recalled_but_difficult)
        let review11 = subject.nextReview(lastReview: review10, currentEvaluation: evaluation11)
        XCTAssertEqual(review11.easeFactor, 1.94, accuracy: 0.005)
        XCTAssertEqual(review11.numberOfCorrectReviewsInARow, 11)
        XCTAssertEqual(review11.intervalDays, 231, accuracy: 0.01)


    }
    
    
    func testScheduleWithEventualLapses() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.006944444444444444, accuracy: 0.01)

        let evaluation3 = Evaluation(score: Score.recalled_easily)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 4.0, accuracy: 0.01)

        let evaluation4 = Evaluation(score: Score.recalled)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 10.0, accuracy: 0.01)

        let evaluation5 = Evaluation(score: Score.recalled_but_difficult)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 12, accuracy: 0.01)

        let evaluation6 = Evaluation(score: Score.not_recalled)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.16, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review6.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.16, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review7.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.16, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review8.intervalDays, 0.006944444444444444, accuracy: 0.01)

        let evaluation9 = Evaluation(score: Score.recalled)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 2.16, accuracy: 0.005)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review9.intervalDays, 1.0, accuracy: 0.01)
    }
    
    func testScheduleWhereReviewsAreInitiallyHard() {
        let evaluation1 = Evaluation(score: Score.not_recalled_and_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review1.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation2 = Evaluation(score: Score.recalled_but_difficult)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review2.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation3 = Evaluation(score: Score.not_recalled)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review3.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation4 = Evaluation(score: Score.recalled_but_difficult)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review4.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation5 = Evaluation(score: Score.not_recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review5.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review6.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review7.intervalDays, 0.006944444444444444, accuracy: 0.01)

        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review8.intervalDays, 1.0, accuracy: 0.01)

        let evaluation9 = Evaluation(score: Score.recalled_but_difficult)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review9.intervalDays, 2, accuracy: 0.01)

        let evaluation10 = Evaluation(score: Score.recalled_but_difficult)
        let review10 = subject.nextReview(lastReview: review9, currentEvaluation: evaluation10)
        XCTAssertEqual(review10.easeFactor, 2.22, accuracy: 0.005)
        XCTAssertEqual(review10.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review10.intervalDays, 3, accuracy: 0.01)
    }
    
    func testScheduleWhereCardsAreReviewedLateButGotItRight() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.006944444444444444, accuracy: 0.01)

        let evaluation3 = Evaluation(score: Score.recalled_easily)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 4.0, accuracy: 0.01)

        let evaluation4 = Evaluation(score: Score.recalled_but_difficult, lateness: 2)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 5, accuracy: 0.01)
        
        let evaluation5 = Evaluation(score: Score.recalled, lateness: 8)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 59, accuracy: 0.01)

        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.22, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 71, accuracy: 0.01)

        let evaluation7 = Evaluation(score: Score.recalled, lateness: 8)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.22, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 789, accuracy: 0.01)

        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.22, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 1752, accuracy: 0.01)

        let evaluation9 = Evaluation(score: Score.recalled_but_difficult)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 2.08, accuracy: 0.005)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 9)
        XCTAssertEqual(review9.intervalDays, 2103, accuracy: 0.01)

        let evaluation10 = Evaluation(score: Score.recalled)
        let review10 = subject.nextReview(lastReview: review9, currentEvaluation: evaluation10)
        XCTAssertEqual(review10.easeFactor, 2.08, accuracy: 0.005)
        XCTAssertEqual(review10.numberOfCorrectReviewsInARow, 10)
        XCTAssertEqual(review10.intervalDays, 4375, accuracy: 0.01)

        let evaluation11 = Evaluation(score: Score.recalled_but_difficult)
        let review11 = subject.nextReview(lastReview: review10, currentEvaluation: evaluation11)
        XCTAssertEqual(review11.easeFactor, 1.94, accuracy: 0.005)
        XCTAssertEqual(review11.numberOfCorrectReviewsInARow, 11)
        XCTAssertEqual(review11.intervalDays, 5250, accuracy: 0.01)

    }
    
    func testScheduleWhereCardsAreReviewedTooEarly() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.006944444444444444, accuracy: 0.01)

        let evaluation3 = Evaluation(score: Score.recalled_but_difficult, lateness: -0.00625)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.01)

        let evaluation4 = Evaluation(score: Score.recalled, lateness: -6.0)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 3.0, accuracy: 0.01)

        let evaluation5 = Evaluation(score: Score.recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 8.0, accuracy: 0.01)

        let evaluation6 = Evaluation(score: Score.recalled, lateness: -2.0)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 20.0, accuracy: 0.01)

        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 24, accuracy: 0.01)
    }
    
    func testScheduleWhereInitialReviewsAreDoneLate() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation2 = Evaluation(score: Score.recalled_but_difficult, lateness: 0.0006944444444444445)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.006944444444444444, accuracy: 0.01)

        let evaluation3 = Evaluation(score: Score.recalled_but_difficult, lateness: 0.003472222222222222)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.01)

        let evaluation4 = Evaluation(score: Score.recalled, lateness: 0.25)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 3.0, accuracy: 0.01)

        let evaluation5 = Evaluation(score: Score.recalled_but_difficult)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 4, accuracy: 0.01)

        let evaluation6 = Evaluation(score: Score.recalled)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 10, accuracy: 0.01)

        let evaluation7 = Evaluation(score: Score.recalled)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 24, accuracy: 0.01)

        let evaluation8 = Evaluation(score: Score.recalled)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 57, accuracy: 0.01)


    }
    
    func testScheduleWhereCardIsConsistentlyHard() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation2 = Evaluation(score: Score.recalled_but_difficult)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.006944444444444444, accuracy: 0.01)

        let evaluation3 = Evaluation(score: Score.recalled_but_difficult)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.01)

        let evaluation4 = Evaluation(score: Score.recalled_but_difficult)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 2, accuracy: 0.01)
        
        let evaluation5 = Evaluation(score: Score.recalled_but_difficult)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.22, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 3, accuracy: 0.01)

        let evaluation6 = Evaluation(score: Score.recalled_but_difficult)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.08, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 4, accuracy: 0.01)

        let evaluation7 = Evaluation(score: Score.recalled_but_difficult)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 1.94, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 5, accuracy: 0.01)

        let evaluation8 = Evaluation(score: Score.recalled_but_difficult)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 1.8, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 6, accuracy: 0.01)
    }
    
    func testScheduleWhereCardIsConsistentlyReviewedOkay() {
        let evaluation1 = Evaluation(score: Score.recalled)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation2 = Evaluation(score: Score.recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.006944444444444444, accuracy: 0.01)

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
        XCTAssertEqual(review1.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation2 = Evaluation(score: Score.not_recalled)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review2.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation3 = Evaluation(score: Score.not_recalled)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review3.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation4 = Evaluation(score: Score.not_recalled)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review4.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation5 = Evaluation(score: Score.not_recalled)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review5.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation6 = Evaluation(score: Score.not_recalled)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 0)
        XCTAssertEqual(review6.intervalDays, 0.0006944444444444445, accuracy: 0.01)
    }
    
    func testScheduleWhereCardIsReviewedVeryEarly() {
        let evaluation1 = Evaluation(score: Score.recalled_but_difficult)
        let review1 = subject.nextReview(currentEvaluation: evaluation1)
        XCTAssertEqual(review1.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review1.numberOfCorrectReviewsInARow, 1)
        XCTAssertEqual(review1.intervalDays, 0.0006944444444444445, accuracy: 0.01)

        let evaluation2 = Evaluation(score: Score.recalled_but_difficult, lateness: -0.0006944444444444445)
        let review2 = subject.nextReview(lastReview: review1, currentEvaluation: evaluation2)
        XCTAssertEqual(review2.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review2.numberOfCorrectReviewsInARow, 2)
        XCTAssertEqual(review2.intervalDays, 0.006944444444444444, accuracy: 0.01)

        let evaluation3 = Evaluation(score: Score.recalled_but_difficult, lateness: -0.006944444444444444)
        let review3 = subject.nextReview(lastReview: review2, currentEvaluation: evaluation3)
        XCTAssertEqual(review3.easeFactor, 2.5, accuracy: 0.005)
        XCTAssertEqual(review3.numberOfCorrectReviewsInARow, 3)
        XCTAssertEqual(review3.intervalDays, 1.0, accuracy: 0.01)

        let evaluation4 = Evaluation(score: Score.recalled_but_difficult, lateness: -0.9583333333333334)
        let review4 = subject.nextReview(lastReview: review3, currentEvaluation: evaluation4)
        XCTAssertEqual(review4.easeFactor, 2.36, accuracy: 0.005)
        XCTAssertEqual(review4.numberOfCorrectReviewsInARow, 4)
        XCTAssertEqual(review4.intervalDays, 2, accuracy: 0.01)

        let evaluation5 = Evaluation(score: Score.recalled_but_difficult, lateness: -3.0)
        let review5 = subject.nextReview(lastReview: review4, currentEvaluation: evaluation5)
        XCTAssertEqual(review5.easeFactor, 2.22, accuracy: 0.005)
        XCTAssertEqual(review5.numberOfCorrectReviewsInARow, 5)
        XCTAssertEqual(review5.intervalDays, 3, accuracy: 0.01)

        let evaluation6 = Evaluation(score: Score.recalled_but_difficult, lateness: -5.0)
        let review6 = subject.nextReview(lastReview: review5, currentEvaluation: evaluation6)
        XCTAssertEqual(review6.easeFactor, 2.08, accuracy: 0.005)
        XCTAssertEqual(review6.numberOfCorrectReviewsInARow, 6)
        XCTAssertEqual(review6.intervalDays, 4, accuracy: 0.01)

        let evaluation7 = Evaluation(score: Score.recalled_but_difficult, lateness: -10.0)
        let review7 = subject.nextReview(lastReview: review6, currentEvaluation: evaluation7)
        XCTAssertEqual(review7.easeFactor, 1.94, accuracy: 0.005)
        XCTAssertEqual(review7.numberOfCorrectReviewsInARow, 7)
        XCTAssertEqual(review7.intervalDays, 5, accuracy: 0.01)

        let evaluation8 = Evaluation(score: Score.recalled_but_difficult)
        let review8 = subject.nextReview(lastReview: review7, currentEvaluation: evaluation8)
        XCTAssertEqual(review8.easeFactor, 1.8, accuracy: 0.005)
        XCTAssertEqual(review8.numberOfCorrectReviewsInARow, 8)
        XCTAssertEqual(review8.intervalDays, 6, accuracy: 0.01)

        let evaluation9 = Evaluation(score: Score.recalled_but_difficult, lateness: -19.0)
        let review9 = subject.nextReview(lastReview: review8, currentEvaluation: evaluation9)
        XCTAssertEqual(review9.easeFactor, 1.66, accuracy: 0.005)
        XCTAssertEqual(review9.numberOfCorrectReviewsInARow, 9)
        XCTAssertEqual(review9.intervalDays, 8, accuracy: 0.01)

        let evaluation10 = Evaluation(score: Score.recalled_but_difficult, lateness: -28.0)
        let review10 = subject.nextReview(lastReview: review9, currentEvaluation: evaluation10)
        XCTAssertEqual(review10.easeFactor, 1.52, accuracy: 0.005)
        XCTAssertEqual(review10.numberOfCorrectReviewsInARow, 10)
        XCTAssertEqual(review10.intervalDays, 10, accuracy: 0.01)

        let evaluation11 = Evaluation(score: Score.recalled_but_difficult, lateness: -39.0)
        let review11 = subject.nextReview(lastReview: review10, currentEvaluation: evaluation11)
        XCTAssertEqual(review11.easeFactor, 1.38, accuracy: 0.005)
        XCTAssertEqual(review11.numberOfCorrectReviewsInARow, 11)
        XCTAssertEqual(review11.intervalDays, 12, accuracy: 0.01)

        let evaluation12 = Evaluation(score: Score.recalled_but_difficult, lateness: -51.0)
        let review12 = subject.nextReview(lastReview: review11, currentEvaluation: evaluation12)
        XCTAssertEqual(review12.easeFactor, 1.3, accuracy: 0.005)
        XCTAssertEqual(review12.numberOfCorrectReviewsInARow, 12)
        XCTAssertEqual(review12.intervalDays, 15, accuracy: 0.01)
    }
}
