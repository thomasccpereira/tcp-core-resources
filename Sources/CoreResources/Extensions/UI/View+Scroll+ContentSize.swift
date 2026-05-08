import SwiftUI
import Foundation

public var ScrollContentSizePreferenceNamed: String { "ScrollableContentSize" }

public extension View {
   func onScrollContentSize(closure: @escaping (CGSize) -> Void) -> some View {
      self.modifier(ScrollContentSizeOverlayModifier(size: closure))
   }
}

// MARK: - PreferenceKey
fileprivate struct ScrollContentSizePreferenceKey: PreferenceKey {
   static var defaultValue: CGSize { .zero }
   
   static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
      value = nextValue()
   }
}

// MARK: - ViewModifier
fileprivate struct ScrollContentSizeOverlayModifier: ViewModifier {
   let size: (CGSize) -> Void
   
   func body(content: Content) -> some View {
      content
         .overlay(alignment: .topLeading) {
            GeometryReader { geo in
               Color.clear
                  .preference(
                     key: ScrollContentSizePreferenceKey.self,
                     value: geo.size
                  )
            }
         }
         .onPreferenceChange(ScrollContentSizePreferenceKey.self) { size in
            self.size(size)
         }
   }
}
