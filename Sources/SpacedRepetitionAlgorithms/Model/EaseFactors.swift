/// An ease factor represents how difficult a learning unit is considered to recall. If an information is considered difficult to recall (= a low ease factor), the proposed time interval between two reviews will be shorter.
struct EaseFactors {
    static let veryDifficult = 1.3
    static let veryEasy = 2.5
    static let defaultEaseFactor = veryEasy
}
