/// The scoring system is based on 5-point scale and comes from SuperMemo’s SM-2 algorithm
/// comments from https://www.freshcardsapp.com/srs/write-your-own-algorithm.html
enum Score: Int, Comparable, Equatable {

    /// 5 means the information was recalled easily
    case recalled_easily = 5
    
    /// 4 means the information was recalled with a medium difficulty level
    case recalled = 4
    
    /// 3 means the information was recalled but it was difficult
    case recalled_but_difficult = 3
    
    /// 2 means the information was not recalled but seeing the correct answer "sparked" the memory
    case not_recalled = 2
    
    /// 1 means the information was not recalled and the answer looked very foreign
    case not_recalled_and_difficult = 1
    
    /// a score of 3 and higher means the information was recalled
    func wasRecalled() -> Bool {
        switch self {
            case Score.recalled_easily, Score.recalled, Score.recalled_but_difficult:
                return true
            default:
                return false
        }
    }
    
    static func < (lhs: Score, rhs: Score) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
