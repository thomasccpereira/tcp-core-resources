import Foundation

// MARK: - Init
public extension Date {
   init?(day: Int,
         month: Int,
         year: Int,
         hour: Int = 0,
         minute: Int = 0,
         seconds: Int = 0) {
      var dateComponents = DateComponents()
      dateComponents.day = day
      dateComponents.month = month
      dateComponents.year = year
      dateComponents.hour = hour
      dateComponents.minute = minute
      dateComponents.second = seconds
      
      guard let date = Calendar.current.date(from: dateComponents) else { return nil }
      self = date
   }
}

// MARK: - Datetime
public extension Date {
   var localTime: Date { self } // or delete this property
   
   static var uses24Hours: Bool {
      guard let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current) else { return true }
      return dateFormat.firstIndex(of: "a") == nil
   }
   
   static var nowTimeIntervalSince2001: TimeInterval {
      let now: Date = .now
      // SwiftData dates are stored considering the timeinterval since
      // January 1, 2001, GMT, so we need to adjust the timeinterval
      // since 1970
      // https://www.epochconverter.com/coredata
      let timeInterval = now.timeIntervalSince1970 - 978307200.0
      return timeInterval
   }
}

// MARK: - Comparision
public extension Date {
   func isSameDate(_ comparedDate: Date) -> Bool {
      let calendar = Calendar.current
      let components: Set<Calendar.Component> = [.day, .month, .year]
      let lhsComponents = calendar.dateComponents(components, from: self)
      let rhsComponents = calendar.dateComponents(components, from: comparedDate)
      return lhsComponents == rhsComponents
   }
}

// MARK: - Operations
public extension Date {
   var plusOneHour: Date { adding(.hour) }
   
   func adding(_ adding: Calendar.Component, value: Int = 1) -> Date {
      Calendar.current.date(byAdding: adding, value: value, to: self) ?? self
   }
}

// MARK: - Day
public extension Date {
   var day: Int {
      Calendar.current.component(.day, from: self)
   }
   
   var startOfDay: Date {
      Calendar.current.startOfDay(for: self)
   }
   
   var endOfDay: Date {
      var dateComponents = DateComponents()
      dateComponents.day = 1
      dateComponents.second = -1
      return Calendar.current.date(byAdding: dateComponents, to: startOfDay)!
   }
   
   static var yesterday: Date {
      let adding = DateComponents(day: -1)
      let yesterday = Calendar.current.date(byAdding: adding, to: .now)
      return yesterday?.endOfDay ?? .now
   }
   
   func daysTo(_ to: Date) -> Int {
      let from = self.startOfDay
      let to = to.startOfDay
      return Calendar.current.dateComponents([.day], from: from, to: to).day ?? 0
   }
   
   func daysAgo(_ days: Int) -> Date {
      return Calendar.current.date(byAdding: .day, value: -days, to: self.startOfDay)?.endOfDay ?? .now.endOfDay
   }
}

// MARK: - Month
public extension Date {
   var month: Int {
      Calendar.current.component(.month, from: self)
   }
   
   static var startOfMonth: Date {
      (Calendar.current.dateInterval(of: .month, for: .now)?.start.advanced(by: 1000) ?? .now)
   }
   
   static var endOfMonth: Date {
      (Calendar.current.dateInterval(of: .month, for: .now)?.end.advanced(by: -1000) ?? .now)
   }
   
   static var currentMonthRange: ClosedRange<Date> {
      (startOfMonth ... endOfMonth)
   }
   
   static func isDateInCurrentMonth(_ date: Date?) -> Bool {
      guard let date else { return false }
      return currentMonthRange.contains(date)
   }
}

// MARK: - Year
public extension Date {
   var year: Int {
      Calendar.current.component(.year, from: self)
   }
}
