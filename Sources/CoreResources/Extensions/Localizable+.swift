import Foundation

public func localized(_ localizedKey: String, comment: String = "", args: CVarArg..., bundle: Bundle = .main) -> String {
   let localizedString = NSLocalizedString(localizedKey, bundle: bundle, comment: comment)
   if !args.isEmpty {
      return String(format: localizedString, arguments: args)
   }
   return localizedString
}
