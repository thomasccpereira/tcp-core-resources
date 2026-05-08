import Observation
import Foundation

/// Creates a MainActor observation task that re-arms on every change.
/// Call `cancel()` on the returned Task when you want to stop observing.
@MainActor
public func makeObservationTask<T>(of expr: @escaping () -> T,
                                   fireImmediately: Bool = false,
                                   onChangeAsync: @escaping (T) async -> Void) -> Task<Void, Never> {
   Task { @MainActor in
      if fireImmediately {
         await onChangeAsync(expr())
      }
      
      while !Task.isCancelled {
         // Suspend until a change is observed, then loop again.
         await withCheckedContinuation { cont in
            withObservationTracking {
               _ = expr()
            } onChange: {
               cont.resume()
            }
         }
         
         if Task.isCancelled { break }
         await onChangeAsync(expr())
      }
   }
}
