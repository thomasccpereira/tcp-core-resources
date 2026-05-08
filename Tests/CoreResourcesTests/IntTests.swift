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
}
