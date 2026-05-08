import SwiftUI

public extension Alignment {
   var multiline: TextAlignment {
      switch self {
      case .center, .top, .bottom, .centerFirstTextBaseline, .centerLastTextBaseline: .center
      case .leading, .topLeading, .bottomLeading, .leadingFirstTextBaseline, .leadingLastTextBaseline: .leading
      case .trailing, .topTrailing, .bottomTrailing, .trailingFirstTextBaseline, .trailingLastTextBaseline: .trailing
      default: .leading
      }
   }
}
