import Foundation

/// This algorithm is similar to the algorithm used in the popular flashcards app "Anki".
/// Compared to other algorithms, the initial reviews are shorter. The algorithm differentiates between the initial "learning" phase and the "reviewing" phase. During the learning phase, the ease factor is not changed. The algorithm considers how "late" or "early" a card is reviewed. If a card is reviewed late but the answer was still right, the timespan of the next interval is further increased. On the other hand, if a card is reviewed to early, the timeinerval isn't increased as much as when the card is reviewed on time. A random value is added to the resulting interval to avoid that the same learning reviewes are always grouped together.
open class AnkiLikeAlgorithm: SpacedRepetitionAlgorithm {
    
    /// Controls wether a random value should be added to the time intervals. If this option is turned on, it prevents that the same learning units are always "grouped" together.
    public let addFuzzyness: Bool
    
    public init(addFuzzyness: Bool = false) {
        self.addFuzzyness = addFuzzyness
    }
    
    open func nextInterval(lastReview: Review = Review(), currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        if (lastReview.isInLearningPhase) {
            return nextIntervalForLearningPhase(lastReview: lastReview, currentEvaluation: currentEvaluation)
        } else {
            return nextIntervalForReviewingPhase(lastReview: lastReview, currentEvaluation: currentEvaluation, easeFactor: easeFactor)
        }
    }
    
    open func nextEaseFactor(lastReview: Review, currentEvaluation: Evaluation) -> Double {
        if (lastReview.isInLearningPhase) {
            return nextEaseFactorForLearningPhase(lastReview: lastReview)
        }
        
        return nextEaseFactorForReviewPhase(lastReview: lastReview, currentEvaluation: currentEvaluation)
    }
    
    private func nextIntervalForLearningPhase(lastReview: Review, currentEvaluation: Evaluation) -> Double {
        switch currentEvaluation.score {
        case .recalled_easily: return 4
        case .recalled, .recalled_but_difficult:
            switch lastReview.numberOfCorrectReviewsInARow { //card was recalled but not recalled easily
            case 0: return numberOfDays(fromMinutes: 1.0)
            case 1: return numberOfDays(fromMinutes: 10.0)
            default: return 1.0
            }
        case .not_recalled: return numberOfDays(fromMinutes: 1)
        case .not_recalled_and_difficult: return numberOfDays(fromMinutes: 1)
        }
    }
    
    private func nextIntervalForReviewingPhase(lastReview: Review, currentEvaluation: Evaluation, easeFactor: Double) -> Double {
        if (!currentEvaluation.score.wasRecalled()) {
            return numberOfDays(fromMinutes: 1.0)
        }
        
        let latenessBonus = latenessBonus(lastReview: lastReview, currentEvaluation: currentEvaluation)
        let workingEaseFactor = calculateWorkingEaseFactor(score: currentEvaluation.score, easeFactor: easeFactor)
        var interval = ceil((lastReview.intervalDays + latenessBonus) * workingEaseFactor)
        
        if (currentEvaluation.score == Score.recalled_but_difficult) {
            //if the information unit was recalled but still difficult, the interval is just increased by 1.2 - the value of the working ease factor is ignored in this case.
            interval = ceil(lastReview.intervalDays * 1.2)
        }
        
        if (addFuzzyness) {
            interval += fuzz(forInterval: interval)
        }
        
        return interval
    }
    
    private func latenessBonus(lastReview: Review, currentEvaluation: Evaluation) -> Double {
        // if a review was dont later than expected but the information was still recalled, a "bonus" is added to the interval because it is assumed to be more difficult to recall a learning unit after a longer period of time
        let latenessValue = max(0, currentEvaluation.lateness * lastReview.intervalDays)
        
        switch currentEvaluation.score {
        case .recalled_easily: return latenessValue
        case .recalled: return latenessValue / 2.0
        default: return latenessValue / 4.0
        }
    }
    
    private func fuzz(forInterval interval: Double) -> Double {
        var fuzzRange: Double
        
        switch interval {
        case ..<2:
            fuzzRange = 0
        case 2:
            fuzzRange = 1
        case ..<7:
            fuzzRange = round(interval * 0.25)
        case ..<30:
            fuzzRange = max(2, round(interval * 0.25))
        default:
            fuzzRange = max(4, round(interval * 0.05))
        }
        
        return Double.random(in: 0..<1) * fuzzRange - fuzzRange * 0.5
    }
    
    private func nextEaseFactorForReviewPhase(lastReview: Review, currentEvaluation: Evaluation) -> Double {
        // Reviewing phase
        if (currentEvaluation.score.wasRecalled()) {
            //passed
            return max(EaseFactors.veryDifficult, lastReview.easeFactor + (0.1 - (5 - currentEvaluation.scoreValue) * (0.08+(5 - currentEvaluation.scoreValue)*0.02)))
        } else {
            //failed
            return max(EaseFactors.veryDifficult, lastReview.easeFactor - 0.20)
        }
    }
    
    private func nextEaseFactorForLearningPhase(lastReview: Review) -> Double {
        return lastReview.easeFactor
    }
    
    private func calculateWorkingEaseFactor(score: Score, easeFactor: Double) -> Double {
        
        //The working efactor is used for the calculation of the new timeinterval
        switch score {
        case .recalled_but_difficult: return max(EaseFactors.veryDifficult, easeFactor - 0.15)
        case .recalled_easily: return max(1.3, easeFactor + 0.15)
        default: return easeFactor
        }
    }
    
}
