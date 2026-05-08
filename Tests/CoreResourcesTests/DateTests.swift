import Testing
import Foundation
@testable import CoreResources

fileprivate func isoDate(_ dateString: String) -> Date {
   // ISO 8601 with Zulu timezone (stable across locales)
   let dateFormat = ISO8601DateFormatter()
   dateFormat.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
   return dateFormat.date(from: dateString)!
}

@Suite("Dates tests")
struct DateExtensionTests {
   private var testDate: Date? {
      return Date(day: 1,
                  month: 2,
                  year: 2024,
                  hour: 13,
                  minute: 45,
                  seconds: 30)
   }
   
   // MARK: - Init(day:month:year:hour:minute:seconds:)
   @Test func testInitFromComponents() throws {
      #expect(testDate != nil)
      
      if let testDate {
         let calendar = Calendar.current
         let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: testDate)
         #expect(dateComponents.year == 2024)
         #expect(dateComponents.month == 2)
         #expect(dateComponents.day == 1)
         #expect(dateComponents.hour == 13)
         #expect(dateComponents.minute == 45)
         #expect(dateComponents.second == 30)
      }
   }
   
   // MARK: - Datetime
   @Test func testLocalTimeMatchesTimeZoneShift() {
      let baseDate = Date(timeIntervalSince1970: 1_700_000_000)
      // With the corrected implementation, localTime should be a no‑op.
      #expect(baseDate.localTime == baseDate)
   }
   
   @Test func testUses24HoursMatchesHeuristic() {
      // Recompute expected the same way your property does (but inline here)
      let template = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
      let expected = (template?.firstIndex(of: "a") == nil)
      #expect(Date.uses24Hours == expected)
   }
   
   @Test func testNowTimeIntervalSince2001MatchesReferenceDate() {
      // timeIntervalSinceReferenceDate is already since Jan 1, 2001 GMT.
      let expected = Date.now.timeIntervalSinceReferenceDate
      let got = Date.nowTimeIntervalSince2001
      // Allow tiny drift between the two reads of 'now'
      #expect(abs(got - expected) < 0.01) // 10 ms tolerance
   }
   
   @Test func testIfDateHasPassed() {
      let pastDate: Date? = Date.distantPast
      let today: Date? = Date.now
      let futureDate: Date? = Date.distantFuture
      let nullableDate: Date? = nil
      #expect(pastDate.dateHasPassed == true)
      #expect(today.dateHasPassed == false)
      #expect(futureDate.dateHasPassed == false)
      #expect(nullableDate.dateHasPassed == false)
   }
   
   // MARK: - Day
   @Test func testDay() {
      #expect(testDate != nil)
      #expect(testDate?.day == 1)
   }
   
   @Test func testStartEndOfDayBounds() {
      // Use a fixed-instant date (midday today from Calendar.current)
      let calendar = Calendar.current
      let now = Date()
      var dateComponents = calendar.dateComponents([.year, .month, .day], from: now)
      dateComponents.hour = 12; dateComponents.minute = 0; dateComponents.second = 0
      let midday = calendar.date(from: dateComponents)!
      let localMidday = midday.localTime
      
      let start = midday.startOfDay
      let end = midday.endOfDay
      
      #expect(start <= localMidday)
      #expect(localMidday <= end)
      
      let span = end.timeIntervalSince(start)
      // Typically 86_399 seconds (24h - 1s). Allow small tolerance for odd calendars.
      #expect(span >= 86_398 && span <= 86_401)
   }
   
   @Test func testYesterdayAtEndOfDay() {
      let calendar = Calendar.current
      let now = Date()
      let previous = calendar.date(byAdding: .day, value: -1, to: now)!
      // Expected: previous day's end-of-day using the same logic
      var prevStart = calendar.startOfDay(for: previous)
      prevStart = prevStart.localTime
      let expected = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: prevStart)!.localTime
      
      // SUT
      let yesterday = Date.yesterday
      // Within a second (the property uses .now internally)
      #expect(abs(yesterday.timeIntervalSince(expected)) <= 1.0)
   }
   
   @Test func testDaysToWorks() {
      let calendar = Calendar.current
      var dateComponents = DateComponents(year: 2024, month: 6, day: 10, hour: 15)
      let dateA = calendar.date(from: dateComponents)! // 2024-06-10 15:00
      dateComponents.day = 13
      let dateB = calendar.date(from: dateComponents)! // 2024-06-13 15:00
      
      #expect(dateA.daysTo(dateB) == 3)
      #expect(dateB.daysTo(dateA) == -3)
      #expect(dateA.daysTo(dateA) == 0)
   }
   
   @Test func testDaysAgoEndOfDay() {
      let calendar = Calendar.current
      let dateComponents = DateComponents(year: 2024, month: 6, day: 20, hour: 10, minute: 30)
      let anchor = calendar.date(from: dateComponents)!
      let result = anchor.daysAgo(5)
      
      // Expected: startOfDay(anchor) - 5 days, then endOfDay
      let start = calendar.startOfDay(for: anchor).localTime
      let minusFive = calendar.date(byAdding: .day, value: -5, to: start)!
      let expected = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: minusFive)!.localTime
      
      #expect(result == expected)
   }
   
   // MARK: - Month
   @Test func testMonth() {
      #expect(testDate != nil)
      #expect(testDate?.month == 2)
   }
   
   @Test func testMonthRangeContainsNow() {
      let now = Date()
      let start = Date.startOfMonth
      let end = Date.endOfMonth
      
      // Sanity: start < end and range contains now
      #expect(start < end)
      #expect((start ... end).contains(now))
      #expect(Date.currentMonthRange.contains(now))
   }
   
   @Test func testIsDateInCurrentMonthWorks() {
      let now = Date()
      let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: now)!
      #expect(Date.isDateInCurrentMonth(now))
      #expect(!Date.isDateInCurrentMonth(lastMonth))
      #expect(!Date.isDateInCurrentMonth(nil))
   }
   
   // MARK: - Year
   @Test func testYearComponent() {
      var dateComponents = DateComponents()
      dateComponents.year = 1999; dateComponents.month = 12; dateComponents.day = 31; dateComponents.hour = 23
      let date = Calendar.current.date(from: dateComponents)!
      #expect(date.year == Calendar.current.component(.year, from: date))
      #expect(date.year == 1999)
   }
   
   // MARK: - Date format
   @Suite("Date format tests")
   struct DateFormatTests {
      // Fixed anchor date: 2024-07-05 14:03:09 (local time zone doesn’t matter for date-only formats)
      private var anchor: Date {
         var dateComponents = DateComponents()
         dateComponents.year = 2024; dateComponents.month = 7; dateComponents.day = 5
         dateComponents.hour = 14; dateComponents.minute = 3; dateComponents.second = 9
         return Calendar(identifier: .gregorian).date(from: dateComponents)!
      }
      
      // Reproduce the same logic as DateFormatter.current(...)
      private func format(_ fmt: String, _ date: Date) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.locale = Locale.current
         dateFormatter.dateFormat = fmt
         return dateFormatter.string(from: date)
      }
      
      @Test func testConstants() {
         #expect(DateFormats.prettyShort == "dd/MM/yy")
         #expect(DateFormats.pretty == "dd/MM/yyyy")
         #expect(DateFormats.yearMonth == "yyyy-MM")
         #expect(DateFormats.yearMonthDay == "yyyy-MM-dd")
         #expect(DateFormats.monthNameAndYear == "MMM yyyy")
         #expect(DateFormats.dayAndMonthName == "dd MMM")
      }
      
      @Test func testPrettyShort() {
         let dateString = anchor.prettyShort
         #expect(dateString == format(DateFormats.prettyShort, anchor))
         #expect(dateString.split(separator: "/").last?.count == 2) // 2-digit year
      }
      
      @Test func testPretty() {
         let dateString = anchor.pretty
         #expect(dateString == format(DateFormats.pretty, anchor))
      }
      
      @Test func testYearMonth() {
         let dateString = anchor.yearMonth
         #expect(dateString == format(DateFormats.yearMonth, anchor))
         #expect(dateString.count == 7)
      }
      
      @Test func testYearMonthDay() {
         let dateString = anchor.yearMonthDay
         #expect(dateString == format(DateFormats.yearMonthDay, anchor))
         #expect(dateString.count == 10)
      }
      
      @Test func testDayAndMonthName() {
         let dateString = anchor.dayAndMonthName
         #expect(dateString == format(DateFormats.dayAndMonthName, anchor))
         let parts = dateString.split(separator: " ")
         #expect(parts.count == 2)
         #expect(parts[0].rangeOfCharacter(from: .decimalDigits) != nil)
         #expect(parts[1].rangeOfCharacter(from: .letters) != nil)
      }
   }
   
   // MARK: - AnyDate tests
   @Suite("AnyDate property wrapper tests")
   struct AnyDateTests {
      static func expectedFromProjectParser(_ dateString: String) -> Date? {
         dateString.date
      }
      
      // MARK: - init()
      @Test func testEmptyInit() throws {
         let wrapped = try AnyDate()
         #expect(wrapped.wrappedValue == nil)
      }
      
      // MARK: - init(dateValue:)
      @Test func testDateValueAccepted() throws {
         let expected = isoDate("2024-06-20T10:30:00.000Z")
         let wrapped = try AnyDate(dateValue: expected)
         #expect(wrapped.wrappedValue == expected)
      }
      
      @Test func testDateValueTooOldNullable() throws {
         var dateComponents = DateComponents()
         dateComponents.year = 1900
         dateComponents.month = 6
         dateComponents.day = 20
         
         let date = Calendar(identifier: .gregorian).date(from: dateComponents)!
         let wrapped = try AnyDate(dateValue: date)
         #expect(wrapped.wrappedValue == nil)
      }
      
      @Test func testDateValueInDistantFutureNullable() throws {
         var dateComponents = DateComponents()
         dateComponents.year = 9999
         dateComponents.month = 1
         dateComponents.day = 1
         
         let date = Calendar(identifier: .gregorian).date(from: dateComponents)!
         let wrapped = try AnyDate(dateValue: date)
         #expect(wrapped.wrappedValue == nil)
      }
      
      // MARK: - init(dateString:)
      @Test func testDateStringNilOrEmpty() throws {
         #expect(try AnyDate(dateString: nil).wrappedValue == nil)
         #expect(try AnyDate(dateString: "").wrappedValue == nil)
      }
      
      @Test func testDateStringInvalid() throws {
         #expect(try AnyDate(dateString: "not-a-date").wrappedValue == nil)
      }
      
      @Test func testDateStringValid() throws {
         let dateString = "2023-12-31T23:59:59.000Z"
         // Expect whatever your String.date would parse from that string
         let expected = AnyDateTests.expectedFromProjectParser(dateString)
         let wrapped = try AnyDate(dateString: dateString)
         #expect(wrapped.wrappedValue == expected)
      }
      
      @Test func testDateStringBoundaryRejected() throws {
         // 1900 (rejected)
         let dateStringA = "1900-06-15T00:00:00.000Z"
         #expect(try AnyDate(dateString: dateStringA).wrappedValue == nil)
         
         // 9999 (rejected)
         let dateStringB = "9999-01-01T00:00:00.000Z"
         #expect(try AnyDate(dateString: dateStringB).wrappedValue == nil)
      }
      
      // MARK: - KeyedDecodingContainer
      @Suite("AnyDate init from KeyedDecodingContainer")
      struct AnyDateKeyedDecodingCointainerTests {
         @Test func testKeyedContainerInit() throws {
            struct Harness: Decodable {
               enum CodingKeys: String, Swift.CodingKey {
                  case date
               }
               
               let result: Date?
               
               init(from decoder: Decoder) throws {
                  let container = try decoder.container(keyedBy: CodingKeys.self)
                  let any = try AnyDate(from: container, key: .date)
                  result = any.wrappedValue
               }
            }
            
            // ✅ Use the correct key "date" to match CodingKeys
            let okString = "2024-01-02T03:04:05.000Z"
            let okJSON = #"{"date":"\#(okString)"}"#.data(using: .utf8)!
            let ok = try JSONDecoder().decode(Harness.self, from: okJSON)
            #expect(ok.result == AnyDateTests.expectedFromProjectParser(okString))
            
            let badJSON = #"{"date":"not-a-date"}"#.data(using: .utf8)!
            let bad = try JSONDecoder().decode(Harness.self, from: badJSON)
            #expect(bad.result == nil)
            
            let boundaryString = "1900-12-31T23:59:59.000Z" // rejected by year guard
            let boundaryJSON = #"{"date":"\#(boundaryString)"}"#.data(using: .utf8)!
            let boundary = try JSONDecoder().decode(Harness.self, from: boundaryJSON)
            #expect(boundary.result == nil)
         }
         
         @Test func testSingleValueDecoding() throws {
            let okString = "2022-08-09T10:11:12.000Z"
            let okData = #""\#(okString)""#.data(using: .utf8)!
            let anyOK = try JSONDecoder().decode(AnyDate.self, from: okData)
            #expect(anyOK.wrappedValue == AnyDateTests.expectedFromProjectParser(okString))
            
            let badData = #""not-a-date""#.data(using: .utf8)!
            let anyBad = try JSONDecoder().decode(AnyDate.self, from: badData)
            #expect(anyBad.wrappedValue == nil)
         }
      }
   }
}
