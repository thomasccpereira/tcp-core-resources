import Testing
import Foundation
@testable import CoreResources

@Suite("KeyPath tests")
struct KeyPathsTests {
   struct TestStruct {
      let id: Int
      let name: String
      let isActive: Bool
   }
   
   @Test func testPartialPathName() {
      let path: PartialKeyPath<TestStruct> = \.id
      #expect(path.partialPathName == "id")
   }
   
   @Test func testPathName() {
      let path: KeyPath<TestStruct, String> = \.name
      #expect(path.pathName == "name")
   }
   
   @Test func testMapByKeyPath() {
      let items = [TestStruct(id: 1, name: "A", isActive: true),
                   TestStruct(id: 2, name: "B", isActive: false)]
      
      let ids = items.map(\.id)
      #expect(ids == [1, 2])
      
      let names = items.map(\.name)
      #expect(names == ["A", "B"])
   }
   
   @Test func testSortByKeyPath() {
      let items = [TestStruct(id: 2, name: "B", isActive: false),
                   TestStruct(id: 1, name: "A", isActive: true)]
      
      let sortedById = items.sorted(by: \.id)
      #expect(sortedById[0].id == 1)
      #expect(sortedById[1].id == 2)
      
      let sortedByName = items.sorted(by: \.name)
      #expect(sortedByName[0].name == "A")
      #expect(sortedByName[1].name == "B")
   }
   
   @Test func testBoolKeyPathNegation() {
      let predicate = !(\TestStruct.isActive)
      let item = TestStruct(id: 1, name: "Test", isActive: false)
      #expect(predicate(item) == true)
   }
   
   @Test func testKeyPathComparison() {
      let predicate = \TestStruct.name == "A"
      let item1 = TestStruct(id: 1, name: "A", isActive: true)
      let item2 = TestStruct(id: 2, name: "B", isActive: false)
      
      #expect(predicate(item1) == true)
      #expect(predicate(item2) == false)
   }
}
