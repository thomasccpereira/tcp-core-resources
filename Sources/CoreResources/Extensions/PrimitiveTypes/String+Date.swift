import Foundation

public extension String {
   var date: Date? {
      let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
      let digits = trimmed.digits
      guard !digits.isEmpty else { return nil }
      
      let yearString = digits[0..<4]
      let monthString = digits[4..<6]
      let dayString = digits[6..<8]
      let hourString = digits[8..<10]
      let minuteString = digits[10..<12]
      let secondsString = digits[12..<14]
      
      guard let year = Int(yearString),
            let month = Int(monthString),
            let day = Int(dayString),
            let hour = Int(hourString),
            let minute = Int(minuteString),
            let seconds = Int(secondsString),
            let date = Date(day: day, month: month, year: year, hour: hour, minute: minute, seconds: seconds) else { return nil }
      
      return date
   }
}
