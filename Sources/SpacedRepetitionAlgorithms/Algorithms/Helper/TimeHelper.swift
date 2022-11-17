import Foundation

/// Returns a floating-point value representing the number of days for a given number of minutes. For example, 60 minutes are 1/24 of a day.
/// - Parameter minutes: The number of minutes
/// - Returns: The number of days the minutes do represent.
func numberOfDays(fromMinutes minutes: Double) -> Double {
    return minutes / (24.0 * 60.0)
}

