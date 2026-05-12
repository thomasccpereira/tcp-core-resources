import Foundation

public extension Int {
   /// Creates a `Date` representing today at the given minutes-since-midnight.
   var pickerDateFrom: Date {
      let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
      let base = Calendar.current.date(from: today) ?? Date()
      return Calendar.current.date(bySettingHour: self / 60,
                                   minute: self % 60,
                                   second: 0,
                                   of: base) ?? Date()
   }
}
