import SwiftUI
import Foundation

public var ScrollItemsWidthsPreferenceNamed: String { "ScrollableItemsWidths" }

public typealias ScrollSingleItemWidth = [String: CGFloat]

public extension View {
   func scrollItemWidthOverlay(itemID: String) -> some View {
      self.modifier(ScrollSingleItemWidthOverlayModifier(itemID: itemID))
   }
   
   func onScrollItemsWidthsChange(closure: @escaping (ScrollSingleItemWidth) -> Void) -> some View {
      self.modifier(ScrollItemsWidthsOverlayModifier(itemSize: closure))
   }
}

// MARK: - PreferenceKey
fileprivate struct ScrollItemsWidthsPreferenceKey: PreferenceKey {
   static var defaultValue: ScrollSingleItemWidth { [:] }
   
   static func reduce(value: inout ScrollSingleItemWidth, nextValue: () -> ScrollSingleItemWidth) {
      let rounded = nextValue().mapValues { $0.rounded(.toNearestOrAwayFromZero) }
      value.merge(rounded, uniquingKeysWith: { $1 })
   }
}

// MARK: - ViewModifier
fileprivate struct ScrollSingleItemWidthOverlayModifier: ViewModifier {
   let itemID: String
   
   func body(content: Content) -> some View {
      content
         .overlay(alignment: .topLeading) {
            GeometryReader { geo in
               Color.clear
                  .preference(
                     key: ScrollItemsWidthsPreferenceKey.self,
                     value: [itemID: geo.size.width]
                  )
            }
         }
   }
}

fileprivate struct ScrollItemsWidthsOverlayModifier: ViewModifier {
   let itemSize: (ScrollSingleItemWidth) -> Void
   
   func body(content: Content) -> some View {
      content
         .onPreferenceChange(ScrollItemsWidthsPreferenceKey.self) { itemSize in
            self.itemSize(itemSize)
         }
   }
}
