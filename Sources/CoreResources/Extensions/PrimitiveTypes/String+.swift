import Foundation

public extension String {
   var trimmed: String {
      self.trimmingCharacters(in: .whitespacesAndNewlines).condensed.replacingOccurrences(of: "\t", with: "")
   }
   
   var cleaned: String {
      self.trimmed.lowercased()
   }
   
   var escaped: String {
      self.trimmed.replacingOccurrences(of: "'", with: "\'")
   }
   
   var validLines: String {
      self.components(separatedBy: .newlines).filter { !$0.trimmed.isEmpty }.joined(separator: "\n")
   }
   
   // Returns a condensed string, with no extra whitespaces and no new lines.
   var condensed: String {
      replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
   }
   
   // Returns a condensed string, with no whitespaces at all and no new lines.
   var extraCondensed: String {
      replacingOccurrences(of: "[\\s\n]+", with: "", options: .regularExpression, range: nil)
   }
   
   var nilWhenEmpty: String? {
      self.trimmed.isEmpty ? nil : self.trimmed
   }
}
