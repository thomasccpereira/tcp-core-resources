import Foundation

public extension String {
   /// A pragmatic email validation:
   /// - Requires a single '@'
   /// - Disallows empty local/domain parts
   /// - Disallows leading/trailing dot or consecutive dots in the local part
   /// - Requires a simple domain with at least one dot and a 2+ letter TLD
   var isEmailValid: Bool {
      let email = self.trimmingCharacters(in: .whitespacesAndNewlines)
      
      // Must contain exactly one '@'
      let parts = email.split(separator: "@", omittingEmptySubsequences: false)
      guard parts.count == 2 else { return false }
      
      let local = String(parts[0])
      let domain = String(parts[1])
      
      // Local/domain cannot be empty
      guard !local.isEmpty, !domain.isEmpty else { return false }
      
      // Local part constraints
      if local.hasPrefix("." ) || local.hasSuffix(".") { return false }
      if local.contains("..") { return false }
      
      // Basic shape for remainder; case‑insensitive
      // Local: allowed ASCII atoms
      // Domain: labels separated by dots, final TLD at least 2 chars
      let pattern = #"^[A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,}$"#
      let predicate = NSPredicate(format: "SELF MATCHES[c] %@", pattern)
      return predicate.evaluate(with: email)
   }
}
