import SwiftUI
import Foundation

public extension View {
   func flipped(_ axis: Axis = .horizontal) -> some View {
      switch axis {
      case .horizontal: self.scaleEffect(x: -1, y: 1)
      case .vertical: self.scaleEffect(x: 1, y: -1)
      }
   }
   
   func withoutAnimation(action: @escaping () -> Void) {
      var transaction = Transaction()
      transaction.disablesAnimations = true
      withTransaction(transaction) {
         action()
      }
   }
}
