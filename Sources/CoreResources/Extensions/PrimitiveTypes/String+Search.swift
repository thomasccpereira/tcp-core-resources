import Foundation

public extension String {
   func isCaseAndDiacriticInsensitiveEqual(_ to: String) -> Bool {
      let result = self.compare(to, options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
      return result == .orderedSame
   }
   
   func containsText(_ text: String?, defaultValue: Bool = true) -> Bool {
      guard let text, !text.trimmed.isEmpty else { return defaultValue }
      return self.lowercased().contains(text.trimmed.lowercased())
   }
}
