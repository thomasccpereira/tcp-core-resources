import SwiftUI
import Foundation

public var ScrollOffsetPreferenceNamed: String { "ScrollablePaging" }

public extension View {
   func onScrollOffsetChange(closure: @escaping (CGFloat) -> Void) -> some View {
      self.modifier(ScrollOffsetOverlayModifier(offset: closure))
   }
}

// MARK: - PreferenceKey
fileprivate struct ScrollOffsetPreferenceKey: PreferenceKey {
   static var defaultValue: CGFloat { 0.0 }
   
   static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value = nextValue()
   }
}

// MARK: - ViewModifier
fileprivate struct ScrollOffsetOverlayModifier: ViewModifier {
   let offset: (CGFloat) -> Void
   
   func body(content: Content) -> some View {
      content
         .overlay(alignment: .topLeading) {
            GeometryReader { geo in
               Color.clear
                  .preference(
                     key: ScrollOffsetPreferenceKey.self,
                     value: -geo.frame(in: .named(ScrollOffsetPreferenceNamed)).origin.x
                  )
            }
         }
         .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
            self.offset(offset)
         }
   }
}
