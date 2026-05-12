import Foundation

public extension Int {
   /// Non-negative modulo — always returns a value in `0..<modulus`.
   func nonNegativeMod(_ modulus: Int) -> Int {
      let result = self % modulus
      return result < 0 ? result + modulus : result
   }
}
