import Foundation

public extension Int {
   /// Computes the minute delta between two IANA timezone identifiers at the current moment.
   func minutesDelta(from sourceTZID: String,
                     to targetTZID: String) -> Int {
      let now = Date()
      let sourceTZ = TimeZone(identifier: sourceTZID) ?? .current
      let targetTZ = TimeZone(identifier: targetTZID) ?? .current
      let deltaSeconds = targetTZ.secondsFromGMT(for: now) - sourceTZ.secondsFromGMT(for: now)
      return deltaSeconds / 60
   }
}
