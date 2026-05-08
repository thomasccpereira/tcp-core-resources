import Testing
import Foundation
@testable import CoreResources

// MARK: - Helpers
// Returns the bundle that serves strings for a given locale (e.g. "en", "pt-BR")
private func bundle(for localeIdentifier: String, in base: Bundle = .module) -> Bundle {
   // .lproj works for .strings and String Catalog (.xcassets) localizations
   if let path = base.path(forResource: localeIdentifier, ofType: "lproj"),
      let bundle = Bundle(path: path) {
      return bundle
   }
   
   // If not found, fall back to the base bundle so tests still run
   return base
}

@Suite("Localizable tests")
struct LocalizableTests {
   // Replace these with keys that exist in your StringCatalog
   private let welcomeKey = "unit_test_welcome_message"
   private let valueKey = "unit_test_key"
   private let missingKey = "___missing_test_key___" // intentionally absent
   
   @Test func testEnglish() {
      let en = bundle(for: "en")
      let welcome = localized(welcomeKey, args: "John", bundle: en)
      let value = localized(valueKey, bundle: en)
      
      // Assert exact expected English values from your catalog:
      #expect(welcome == "Welcome, John!")
      #expect(value == "Test Value")
   }
   
   @Test func testBrazilianPortuguese() {
      let ptBR = bundle(for: "pt-BR")
      let welcome = localized(welcomeKey, args: "João", bundle: ptBR)
      let value = localized(valueKey, bundle: ptBR)
      
      // Assert exact expected Brazilian Portuguese values from your catalog:
      #expect(welcome == "Bem-vindo, João!")
      #expect(value == "Valor de teste")
   }
   
   @Test func testMissingKeyFallback() {
      let en = bundle(for: "en")
      #expect(localized(missingKey, bundle: en) == missingKey)
      
      let ptBR = bundle(for: "pt-BR")
      #expect(localized(missingKey, bundle: ptBR) == missingKey)
   }
}
