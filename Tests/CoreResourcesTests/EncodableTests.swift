import Testing
import Foundation
@testable import CoreResources

@Suite("Encodable tests")
struct EncodableTests {
   private struct Model: Codable {
      let modelID: Int
      let modelName: String
      let modelValue: Double
   }
   
   @Test func testEncodableJSONString() throws {
      let model = Model(modelID: 1, modelName: "Test Model", modelValue: 100.0)
      let jsonString = try model.json
      #expect(jsonString == "{\"modelID\":1,\"modelName\":\"Test Model\",\"modelValue\":100}")
   }

   @Test func testEncodableJSONThrowsForInvalidFloatingPoint() {
      struct InvalidModel: Encodable {
         let value: Double
      }

      let model = InvalidModel(value: .nan)

      do {
         _ = try model.json
         Issue.record("Expected encoding to fail for NaN")
      } catch {
         #expect(true)
      }
   }
}
