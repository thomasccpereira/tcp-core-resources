import Testing
import Foundation
@testable import CoreResources

@Suite("Bool tests")
struct BoolTests {
   @Test func testNilWhenFalse() {
      #expect((false).nilWhenFalse == nil)
      #expect((true).nilWhenFalse == true)
   }
   
   @Test func testIntValue() {
      #expect((true).intValue == 1)
      #expect((false).intValue == 0)
   }
   
   @Suite("Bool comparable tests")
   struct BoolComparableTests {
      @Test func testComparablePropertyAndOrder() {
         let boolFalse = false.comparable
         let boolTrue = true.comparable
         #expect(boolFalse < boolTrue)
         #expect(boolFalse != boolTrue)
         #expect((false.comparable) == .false)
         #expect((true.comparable) == .true)
      }
      
      @Test func testExpressibleByBooleanLiteral() {
         let boolA: Bool.Comparable = true
         let boolB: Bool.Comparable = false
         #expect(boolA == .true)
         #expect(boolB == .false)
      }
      
      @Test func testDecodingComparable() throws {
         let enc = JSONEncoder()
         let dec = JSONDecoder()
         
         // Encode the enum cases using Swift's synthesized Codable
         let dataTrue  = try enc.encode(Bool.Comparable.true)
         let dataFalse = try enc.encode(Bool.Comparable.false)
         
         // Now decode them back and verify
         let decodedTrue  = try dec.decode(Bool.Comparable.self, from: dataTrue)
         let decodedFalse = try dec.decode(Bool.Comparable.self, from: dataFalse)
         
         #expect(decodedTrue == .true)
         #expect(decodedFalse == .false)
      }
   }
   
   @Suite("AnyBool tests")
   struct AnyBoolDecodingTests {
      struct Container: Decodable {
         @AnyBool var flag: Bool
      }
      
      @Test func testInitFromBool() throws {
         let boolTrue = try AnyBool(boolValue: true)
         let boolFalse = try AnyBool(boolValue: false)
         #expect(boolTrue.wrappedValue == true)
         #expect(boolFalse.wrappedValue == false)
      }
      
      @Test func testDecodeFromString() throws {
         let jsonTrue = #"{"flag":"true"}"#.data(using: .utf8)!
         let jsonFalse = #"{"flag":"false"}"#.data(using: .utf8)!
         let dec = JSONDecoder()
         #expect(try dec.decode(Container.self, from: jsonTrue).flag == true)
         #expect(try dec.decode(Container.self, from: jsonFalse).flag == false)
      }
      
      @Test func testDecodeFromInt() throws {
         let json1 = #"{"flag":1}"#.data(using: .utf8)!
         let json0 = #"{"flag":0}"#.data(using: .utf8)!
         let dec = JSONDecoder()
         #expect(try dec.decode(Container.self, from: json1).flag == true)
         #expect(try dec.decode(Container.self, from: json0).flag == false)
      }
      
      @Test func testDecodeFromBoolOrGarbage() throws {
         let json = #"{"flag":true}"#.data(using: .utf8)!
         let dec = JSONDecoder()
         #expect(try dec.decode(Container.self, from: json).flag == true)
         
         let garbage = #"{"flag":{"unexpected":1}}"#.data(using: .utf8)!
         let decoded = try? dec.decode(Container.self, from: garbage)
         #expect(decoded == nil || decoded!.flag == false)
      }
      
      // MARK: - KeyedDecodingContainer
      @Suite("AnyBool init from KeyedDecodingContainer")
      struct AnyBoolKeyedDecodingCointainerTests {
         // A tiny harness that exposes the result after invoking your keyed init.
         private struct Harness: Decodable {
            enum CodingKeys: String, Swift.CodingKey {
               case flag
            }
            
            let result: Bool
            
            init(from decoder: Decoder) throws {
               let container = try decoder.container(keyedBy: CodingKeys.self)
               // Call the initializer under test:
               self.result = try AnyBool(from: container, key: .flag, defaultValue: false).wrappedValue
            }
         }
         
         @Test func testFromString() throws {
            let dec = JSONDecoder()
            
            let t = try dec.decode(Harness.self, from: #"{"flag":"true"}"#.data(using: .utf8)!)
            #expect(t.result == true)
            
            let f = try dec.decode(Harness.self, from: #"{"flag":"false"}"#.data(using: .utf8)!)
            #expect(f.result == false)
            
            // Unknown strings should fall back to false via AnyBool(stringValue:)
            let u = try dec.decode(Harness.self, from: #"{"flag":"not-a-bool"}"#.data(using: .utf8)!)
            #expect(u.result == false)
         }
         
         @Test func testFromInt() throws {
            let dec = JSONDecoder()
            
            let one = try dec.decode(Harness.self, from: #"{"flag":1}"#.data(using: .utf8)!)
            #expect(one.result == true)
            
            let zero = try dec.decode(Harness.self, from: #"{"flag":0}"#.data(using: .utf8)!)
            #expect(zero.result == false)
         }
         
         @Test func testFromBool() throws {
            let dec = JSONDecoder()
            
            let t = try dec.decode(Harness.self, from: #"{"flag":true}"#.data(using: .utf8)!)
            #expect(t.result == true)
            
            let f = try dec.decode(Harness.self, from: #"{"flag":false}"#.data(using: .utf8)!)
            #expect(f.result == false)
         }
         
         @Test func testMissingKeyDefault() throws {
            // Same harness but with defaultValue: true to verify the fallback.
            struct HarnessDefaultTrue: Decodable {
               enum K: String, Swift.CodingKey { case flag }
               let result: Bool
               init(from decoder: Decoder) throws {
                  let c = try decoder.container(keyedBy: K.self)
                  self.result = try AnyBool(from: c, key: .flag, defaultValue: true).wrappedValue
               }
            }
            
            let dec = JSONDecoder()
            let json = #"{"other": 123}"#.data(using: .utf8)!
            let h = try dec.decode(HarnessDefaultTrue.self, from: json)
            #expect(h.result == true)
         }
      }
   }

}
