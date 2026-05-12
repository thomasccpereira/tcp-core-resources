import Testing
import Foundation
@testable import CoreResources

@Suite("URL tests")
struct URLTests {
   @Test func testIsDirectoryForDirectoryAndFile() throws {
      let tempRoot = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
      let dirURL = tempRoot.appendingPathComponent("dir", isDirectory: true)
      let fileURL = tempRoot.appendingPathComponent("file.txt")
      
      try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
      FileManager.default.createFile(atPath: fileURL.path(), contents: Data("a".utf8))
      
      #expect(dirURL.isDirectory == true)
      #expect(fileURL.isDirectory == false)
      
      try? FileManager.default.removeItem(at: tempRoot)
   }
   
   @Test func testIsVideo() {
      #expect(URL(fileURLWithPath: "/tmp/movie.mp4").isVideo == true)
      #expect(URL(fileURLWithPath: "/tmp/image.png").isVideo == false)
      #expect(URL(fileURLWithPath: "/tmp/readme").isVideo == false)
   }
}
