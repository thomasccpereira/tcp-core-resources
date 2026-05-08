import SwiftUI
import Foundation

public extension View {
   func onSizeChange(closure: @escaping (CGSize) -> Void) -> some View {
      self.modifier(ViewContentSizeOverlayModifier(size: closure))
   }
}

// MARK: - PreferenceKey
fileprivate struct ViewContentSizePreferenceKey: PreferenceKey {
   static let defaultValue: CGSize = .zero
   
   static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
      value = nextValue()
   }
}

// MARK: - ViewModifier
fileprivate struct ViewContentSizeOverlayModifier: ViewModifier {
   let size: (CGSize) -> Void
   
   func body(content: Content) -> some View {
      content
         .overlay(alignment: .topLeading) {
            GeometryReader { geo in
               Color.clear.preference(
                  key: ViewContentSizePreferenceKey.self,
                  value: geo.size
               )
            }
         }
         .onPreferenceChange(ViewContentSizePreferenceKey.self) { size in
            self.size(size)
         }
   }
}

