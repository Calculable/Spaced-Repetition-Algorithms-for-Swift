/// An ease factor represents how difficult to recall an information is considered. If an information is considered difficult to recall (= a low ease factor), the time interval between two reviews will be shorter.
struct EaseFactors {
    static let veryDifficult = 1.3
    static let veryEasy = 2.5
    static let defaultEaseFactor = veryEasy
}
