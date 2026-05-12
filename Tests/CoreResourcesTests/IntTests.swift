import Testing
import Foundation
@testable import CoreResources

@Suite("Int tests")
struct IntTests {
   @Test func testZeroWhenNil() {
      let intA: Int? = nil
      let intB: Int? = 42
      #expect(intA.zeroWhenNil == "0")
      #expect(intB.zeroWhenNil == "42")
   }
   
   @Test func testEmptyWhenNil() {
      let intA: Int? = nil
      let intB: Int? = 7
      #expect(intA.emptyWhenNil == "")
      #expect(intB.emptyWhenNil == "7")
   }

   @Test func testPickerDateFromZeroMinutes() {
      let result = 0.pickerDateFrom
      let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)
      let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())

      #expect(components.year == today.year)
      #expect(components.month == today.month)
      #expect(components.day == today.day)
      #expect(components.hour == 0)
      #expect(components.minute == 0)
      #expect(components.second == 0)
   }

   @Test func testPickerDateFromConvertsMinutesToHourAndMinute() {
      let result = 75.pickerDateFrom
      let components = Calendar.current.dateComponents([.hour, .minute, .second], from: result)

      #expect(components.hour == 1)
      #expect(components.minute == 15)
      #expect(components.second == 0)
   }

   @Test func testPickerDateFromEndOfDay() {
      let result = 1439.pickerDateFrom
      let components = Calendar.current.dateComponents([.hour, .minute, .second], from: result)

      #expect(components.hour == 23)
      #expect(components.minute == 59)
      #expect(components.second == 0)
   }

   @Test func testNonNegativeMod() {
      #expect(5.nonNegativeMod(24) == 5)
      #expect((-1).nonNegativeMod(24) == 23)
      #expect((-25).nonNegativeMod(24) == 23)
      #expect(24.nonNegativeMod(24) == 0)
   }

   @Test func testMinutesDeltaInvariantsAndFallback() {
      let same = 0.minutesDelta(from: "America/New_York", to: "America/New_York")
      #expect(same == 0)

      let nyToLondon = 0.minutesDelta(from: "America/New_York", to: "Europe/London")
      let londonToNy = 0.minutesDelta(from: "Europe/London", to: "America/New_York")
      #expect(nyToLondon == -londonToNy)

      let invalidToInvalid = 0.minutesDelta(from: "INVALID_A", to: "INVALID_B")
      #expect(invalidToInvalid == 0)
   }
}
