import Foundation

// MARK: - Date format
public struct DateFormats {
   static let prettyShort = "dd/MM/yy"
   static let pretty = "dd/MM/yyyy"
   static let yearMonth = "yyyy-MM"
   static let yearMonthDay = "yyyy-MM-dd"
   static let monthNameAndYear = "MMM yyyy"
   static let dayAndMonthName = "dd MMM"
   static let weekday = "EEEE"
   static let dateTime = "dd/MM/yyyy HH:mm"
   fileprivate static let dateTimeAMPM = "dd/MM/yyyy hh:mm a"
   static let dateTimeWithSeconds = "yyyy-MM-dd HH:mm:ss"
   fileprivate static let dateTimeWithSecondsAMPM = "yyyy-MM-dd hh:mm:ss a"
   static let time = "HH:mm"
   fileprivate static let timeAMPM = "hh:mm a"
   static let timeWithSeconds = "HH:mm:ss"
   fileprivate static let timeWithSecondsAMPM = "hh:mm:ss a"
}

public extension DateFormatter {
   static func current(dateFormat: String) -> DateFormatter {
      let formatter = DateFormatter()
      formatter.locale = Locale.current
      formatter.dateFormat = dateFormat
      return formatter
   }
}

public extension Date {
   var prettyShort: String { DateFormatter.current(dateFormat: DateFormats.prettyShort).string(from: self) }
   var pretty: String { DateFormatter.current(dateFormat: DateFormats.pretty).string(from: self) }
   var yearMonth: String { DateFormatter.current(dateFormat: DateFormats.yearMonth).string(from: self) }
   var yearMonthDay: String { DateFormatter.current(dateFormat: DateFormats.yearMonthDay).string(from: self) }
   var dayAndMonthName: String { DateFormatter.current(dateFormat: DateFormats.dayAndMonthName).string(from: self) }
   var weekday: String { DateFormatter.current(dateFormat: DateFormats.weekday).string(from: self) }
   var dateTime: String {
      if Date.uses24Hours { return DateFormatter.current(dateFormat: DateFormats.dateTime).string(from: self) }
      return DateFormatter.current(dateFormat: DateFormats.dateTimeAMPM).string(from: self)
   }
   var dateTimeWithSeconds: String {
      if Date.uses24Hours { return DateFormatter.current(dateFormat: DateFormats.dateTimeWithSeconds).string(from: self) }
      return DateFormatter.current(dateFormat: DateFormats.dateTimeWithSecondsAMPM).string(from: self)
   }
   var time: String {
      if Date.uses24Hours { return DateFormatter.current(dateFormat: DateFormats.time).string(from: self) }
      return DateFormatter.current(dateFormat: DateFormats.timeAMPM).string(from: self)
   }
   var timeWithSeconds: String {
      if Date.uses24Hours { return DateFormatter.current(dateFormat: DateFormats.timeWithSeconds).string(from: self) }
      return DateFormatter.current(dateFormat: DateFormats.timeWithSecondsAMPM).string(from: self)
   }
}

public enum GMTOffset {
   /// Formats a GMT offset in seconds into a display-friendly label.
   /// Examples: `"GMT+1"`, `"GMT-5"`, `"GMT+5:30"`, `"GMT-3:45"`
   public static func label(forSeconds seconds: Int) -> String {
      let totalSeconds = abs(seconds)
      let hours = totalSeconds / 3600
      let minutes = (totalSeconds % 3600) / 60
      let sign = seconds >= 0 ? "+" : "-"
      if minutes > 0 {
         return "GMT\(sign)\(hours):\(String(format: "%02d", minutes))"
      }
      return "GMT\(sign)\(hours)"
   }
}

public struct FormattedTime: Equatable {
   let hour: String
   let minute: String
   let period: String
}

/// Converts minutes‑from‑midnight to display strings respecting the device’s 12h/24h preference.
public func formatTime(totalMinutes: Int, uses12Hour: Bool) -> FormattedTime {
   let hour24 = totalMinutes / 60 % 24
   let minute = totalMinutes % 60
   let minuteStr = String(format: "%02d", minute)
   let hourStr: String
   let period: String

   if uses12Hour {
      let display = hour24 % 12
      let display12 = display == 0 ? 12 : display
      hourStr = String(format: "%02d", display12)
      period = hour24 >= 12 ? "PM" : "AM"
   } else {
      hourStr = String(format: "%02d", hour24)
      period = hour24 >= 12 ? "PM" : "AM"
   }
   return FormattedTime(hour: hourStr, minute: minuteStr, period: period)
}

