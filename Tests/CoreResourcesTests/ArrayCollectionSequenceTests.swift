import Testing
import Foundation
@testable import CoreResources

@Suite("Array/Collection/Sequence tests")
struct ArrayCollectionTests {
   @Suite("Test array subcript")
   struct ArraySubcripting {
      @Test func testSafeSubscript() {
         let array = [1, 2, 3]
         
         // Valid index
         #expect(array[safe: 1] == 2)
         
         // Out of bounds index
         #expect(array[safe: 5] == nil)
         
         // Empty collection
         let empty: [Int] = []
         #expect(empty[safe: 0] == nil)
      }
      
      @Test func testSafeSubscriptWithIndexes() {
         let arr = [10, 20, 30]
         #expect(arr[safe: arr.startIndex] == 10)
         #expect(arr[safe: arr.index(after: arr.startIndex)] == 20)
         #expect(arr[safe: arr.endIndex] == nil)
      }
   }
   
   @Suite("Test array item removal")
   struct ArrayRemoving {
      @Test func testRemoveElement() {
         var numbers = [1, 2, 3, 2, 4]
         numbers.remove(element: 2)
         #expect(numbers == [1, 3, 2, 4])
         
         numbers.remove(element: 5) // non-existent element
         #expect(numbers == [1, 3, 2, 4])
         
         var empty: [Int] = []
         empty.remove(element: 1)
         #expect(empty.isEmpty)
      }
   }
   
   @Suite("Test uniqued array")
   struct ArrayUniqued {
      @Test func testUniquedElements() {
         let numbers = [1, 2, 2, 3, 3, 3]
         #expect(numbers.uniqued == [1, 2, 3])
         
         let empty: [Int] = []
         #expect(empty.uniqued.isEmpty)
         
         let strings = ["a", "b", "a", "c"]
         #expect(strings.uniqued == ["a", "b", "c"])
      }
   }
   
   @Suite("Test array with concurrency")
   struct ArrayConcurrency {
      @Test func tetsAsyncMapTest() async throws {
         let numbers = [1, 2, 3]
         let result = await numbers.asyncMap { $0 * 2 }
         #expect(result == [2, 4, 6])
      }
      
      @Test func testAsyncForEachTest() async throws {
         var sum = 0
         let numbers = [1, 2, 3]
         await numbers.asyncForEach { sum += $0 }
         #expect(sum == 6)
      }
      
      @Test func testAsyncCompactMapSkipsNilsPreservesOrder() async throws {
         let input = Array(0..<20)
         let output = try await input.asyncCompactMap { i in
            // simulate async work
            try await Task.sleep(nanoseconds: 200_000)
            return i.isMultiple(of: 3) ? i : nil
         }
         #expect(output == input.filter { $0.isMultiple(of: 3) })
      }
      
      @Test func testAsyncCompactMapPropagatesError() async {
         enum TestError: Error { case boom }
         do {
            _ = try await [0,1,2,3,4].asyncCompactMap { i in
               if i == 3 { throw TestError.boom }
               return i
            }
            Issue.record("Expected TestError.boom to be thrown")
         } catch TestError.boom {
            // ok
         } catch {
            Issue.record("Unexpected error type: \(error)")
         }
      }
      
      @Test func testAsyncCompactMapEmptyInput() async {
         let empty: [Int] = []
         let out = await empty.asyncCompactMap { $0 }
         #expect(out.isEmpty)
      }
      
      @Test func testConcurrentMapPreservesOrder() async throws {
         let input = Array(0..<40)
         let result = try await input.concurrentMap(limit: 4) { i in
            try await Task.sleep(nanoseconds: 200_000 * UInt64(40 - i))
            return i * i
         }
         #expect(result == input.map { $0 * $0 })
      }
      
      @Test func testConcurrentCompactMapSkipsNils() async throws {
         let input = Array(0..<24)
         let result = try await input.concurrentCompactMap(limit: 3) { i in
            try await Task.sleep(nanoseconds: 150_000 * UInt64(24 - i))
            return i.isMultiple(of: 3) ? i : nil
         }
         #expect(result == input.filter { $0.isMultiple(of: 3) })
      }
      
      @Test func testConcurrentMapThrowsAndCancels() async {
         struct E: Error, Equatable {}
         do {
            _ = try await [0,1,2,3,4,5].concurrentMap(limit: 2) { i in
               if i == 3 { throw E() }
               try await Task.sleep(nanoseconds: 1_000_000)
               return i
            }
            Issue.record("Expected error to be thrown")
         } catch is E {
            // ok
         } catch {
            Issue.record("Unexpected error type: \(error)")
         }
      }

      @Test func testConcurrentForEachRunsWithLimitNormalization() async throws {
         actor Collector {
            private(set) var values: [Int] = []

            func append(_ value: Int) {
               values.append(value)
            }
         }

         let input = Array(1...6)
         let collector = Collector()

         try await input.concurrentForEach(limit: 0) { value in
            await collector.append(value)
         }

         let output = await collector.values
         #expect(Set(output) == Set(input))
         #expect(output.count == input.count)
      }

      @Test func testConcurrentForEachEmptyInputReturnsImmediately() async throws {
         actor Counter {
            private(set) var value = 0

            func increment() {
               value += 1
            }
         }

         let input: [Int] = []
         let counter = Counter()

         try await input.concurrentForEach(limit: 2) { _ in
            await counter.increment()
         }

         #expect(await counter.value == 0)
      }
   }
}
