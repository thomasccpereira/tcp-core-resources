import Foundation

public extension String {
   /// Applies the CNPJ mask (XX.XXX.XXX/XXXX-XX) incrementally,
   /// stripping non-digits first. Safe to call on partial or already-formatted input.
   var formattedAsCompanyTaxID: String {
      let digits = self.filter(\.isNumber)
      var result = ""
      for (i, char) in digits.prefix(14).enumerated() {
         switch i {
         case 2, 5: result += "."
         case 8:    result += "/"
         case 12:   result += "-"
         default:   break
         }
         result.append(char)
      }
      return result
   }

   var formattedBrazilianTaxID: String {
      let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
      if trimmed.isEmpty || trimmed.contains(".") { return self }
      
      let numberOfCharacters = trimmed.count
      var result: String? = nil
      if numberOfCharacters == 11 {
         result = "\(trimmed[0..<3]).\(trimmed[3..<6]).\(trimmed[6..<9])-\(trimmed[9...10])"
      } else if numberOfCharacters == 14 {
         result = "\(trimmed[0..<2]).\(trimmed[2..<5]).\(trimmed[5..<8])/\(trimmed[8..<12])-\(trimmed[12...13])"
      }
      
      return result ?? trimmed
   }
}
