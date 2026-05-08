import SwiftUI

public protocol ScrollableContent {
   static var scrollToTopViewID: String { get }
}

public extension ScrollableContent {
   static var scrollToTopViewID: String { "ScrollToTop_\(String(describing: Self.self))" }
}
