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
