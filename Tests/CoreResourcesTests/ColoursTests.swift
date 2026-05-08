
import Testing
import SwiftUI
@testable import CoreResources

@Suite("Color HEX initializers tests")
struct ColorHexTests {
   @Test func testHEXInt() {
      let color = Color(hex: 0xFF0000) // red
      #expect(color == Color(hex: 0xFF0000))
   }
   
   @Test func testHEXString() {
      #expect(Color(hex: "#0000FF") != .black)
      #expect(Color(hex: "#00FF0080") != .black) // with alpha
      #expect(Color(hex: "GGGGGG") == .black)
   }
   
   @Test func testShorthandHEXWhiteAndBlack() {
      #expect(Color(hex: "#000") == .black)
      #expect(Color(hex: "#FFF") == .white)
   }
   
   @Test func testHEXWhiteAndBlack() {
      #expect(Color(hex: "#000000") == .black)
      #expect(Color(hex: "#FFFFFF") == .white)
   }
}
