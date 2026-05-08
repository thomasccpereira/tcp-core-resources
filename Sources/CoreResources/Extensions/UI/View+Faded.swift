import SwiftUI
import Foundation

fileprivate struct DisabledModifier: ViewModifier {
   let disabled: Bool
   let opacity: Double
   
   func body(content: Content) -> some View {
      content
         .opacity(disabled ? opacity : 1.0)
         .disabled(disabled)
   }
}

extension View {
   func grayedOutDisabled(_ disabled: Bool,
                          opacity: Double = 0.3) -> some View {
      self.modifier(DisabledModifier(disabled: disabled,
                                     opacity: opacity))
   }
}
