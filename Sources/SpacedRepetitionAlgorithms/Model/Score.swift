/// The scoring system is based on 5-point scale and comes from SuperMemo’s SM-2 algorithm and is also used for the Anki-Like algorithm and the FreshCards algorithm.
public enum Score: Int, Comparable, Equatable {

    ///5 means that there was no difficulty to recall the learning unit
    case recalled_easily = 5
    
    ///4 is the expected standard-value for a "normal review". Idealy the information unit should be recalled with no big difficulties but also require some amount of thinking.
    case recalled = 4
    
    ///3 means the information was recalled but it was difficult ("almost forgot")
    case recalled_but_difficult = 3
    
    /// 2 means the learning unit was almost recalled (= the correct answer does seem familiar)
    case not_recalled = 2
    
    /// 1 means the information was not recalled. Also, the answer does not seem familiar.
    case not_recalled_and_difficult = 1
    
    public func wasRecalled() -> Bool {
        switch self {
            case Score.recalled_easily, Score.recalled, Score.recalled_but_difficult:
                return true
            default:
                return false
        }
    }
    
    public static func < (lhs: Score, rhs: Score) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
