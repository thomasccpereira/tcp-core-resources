import Testing
import Foundation
import Observation
@testable import CoreResources

@Suite("Observation handler tests")
@MainActor
struct ObservationHandlerTests {
   @Observable
   final class Model {
      var value: Int = 0
   }

   @Test func testFireImmediatelyInvokesCallback() async throws {
      let model = Model()
      var values: [Int] = []

      let task = makeObservationTask(of: { model.value }, fireImmediately: true) { value in
         values.append(value)
      }

      for _ in 0..<20 where values.isEmpty {
         try await Task.sleep(nanoseconds: 1_000_000)
      }

      task.cancel()
      #expect(values.first == 0)
   }

   @Test func testChangeTriggersCallback() async throws {
      let model = Model()
      var values: [Int] = []

      let task = makeObservationTask(of: { model.value }, fireImmediately: true) { value in
         values.append(value)
      }

      // Give the observer loop time to arm before mutating.
      try await Task.sleep(nanoseconds: 2_000_000)
      model.value = 10

      for _ in 0..<60 where !values.contains(10) {
         try await Task.sleep(nanoseconds: 1_000_000)
      }

      task.cancel()
      #expect(values.contains(10))
   }
}
