import Testing
import Foundation
@testable import CoreResources

@Suite("String Extension Tests")
struct StringsTests {
   @Suite
   struct StringManipulating {
      @Test func testStringTrimming() {
         let string = "  hello  \n\t  "
         #expect(string.trimmed == "hello")
      }
      
      @Test func testStringCleaning() {
         let string = "  HéLLo  "
         #expect(string.cleaned == "héllo")
      }
      
      @Test func testStringEscaping() {
         let string = "John's book"
         #expect(string.escaped == "John\'s book")
      }
      
      @Test func testValidLines() {
         let string = "line1\n\nline2\n  \nline3"
         #expect(string.validLines == "line1\nline2\nline3")
      }
      
      @Test func testCondensedString() {
         let string = "hello   \n  world"
         #expect(string.condensed == "hello world")
      }
      
      @Test func testExtraCondensedString() {
         let string = "h e l l o   w o r l d"
         #expect(string.extraCondensed == "helloworld")
      }
      
      @Test func testNilWhenEmpty() {
         let string1 = "  "
         #expect(string1.nilWhenEmpty == nil)
         
         let string2 = " hello "
         #expect(string2.nilWhenEmpty == "hello")
      }
   }
   
   @Suite
   struct StringFormatting {
      @Suite("Brazilian Tax ID formatting tests")
      struct BrazilianTaxIDFormattingTests {
         @Test func testEmptyAndAlreadyFormatted() {
            #expect("".formattedBrazilianTaxID == "")
            let already = "123.456.789-09"
            #expect(already.formattedBrazilianTaxID == already)
         }
         
         @Test func testCPF() {
            let raw = "12345678909"
            let formatted = raw.formattedBrazilianTaxID
            #expect(formatted.contains(".") && formatted.contains("-"))
            #expect(formatted.digits == raw) // structure changed, digits preserved
            
            // Structure check: 3-3-3-2 segments
            let parts = formatted.replacingOccurrences(of: "-", with: ".").split(separator: ".")
            #expect(parts.count == 4)
            #expect(parts[0].count == 3 && parts[1].count == 3 && parts[2].count == 3 && parts[3].count == 2)
         }
         
         @Test func testCNPJ() {
            let raw = "11222333000181"
            let formatted = raw.formattedBrazilianTaxID
            #expect(formatted.contains(".") && formatted.contains("/") && formatted.contains("-"))
            #expect(formatted.digits == raw)
            
            // Structure check: 2.3.3/4-2
            let parts = formatted
               .replacingOccurrences(of: "-", with: ".")
               .replacingOccurrences(of: "/", with: ".")
               .split(separator: ".")
            #expect(parts.count == 5)
            #expect(parts[0].count == 2 && parts[1].count == 3 && parts[2].count == 3 && parts[3].count == 4 && parts[4].count == 2)
         }
         
         @Test func testOtherLengthsPassthrough() {
            #expect("123".formattedBrazilianTaxID == "123")
            #expect("  12345  ".formattedBrazilianTaxID == "12345")
         }
         
         @Test func testFormattedAsCompanyTaxIDIncrementalMask() {
            #expect("1".formattedAsCompanyTaxID == "1")
            #expect("12".formattedAsCompanyTaxID == "12")
            #expect("123".formattedAsCompanyTaxID == "12.3")
            #expect("123456789".formattedAsCompanyTaxID == "12.345.678/9")
            #expect("1234567890123".formattedAsCompanyTaxID == "12.345.678/9012-3")
         }
         
         @Test func testFormattedAsCompanyTaxIDStripsAndTruncates() {
            #expect("12a34b56c7890d1234".formattedAsCompanyTaxID == "12.345.678/9012-34")
         }
      }
   }
   
   @Suite
   struct StringRanging {
      @Test func testClosedRangeAtBounds() {
         #expect("Hello, World"[0...4] == "Hello")
      }
      
      @Test func testHalfOpenRangeAtBounds() {
         #expect("Hello, World"[0..<5] == "Hello")
      }
      
      @Test func testSingleCharacterRange() {
         #expect("Hello, World"[2...2] == "l")
      }
   }
   
   @Suite
   struct StringDateParsing {
      @Test func testStringDateValid() {
         let parsed = "2024-07-05T14:03:09".date
         #expect(parsed != nil)
         let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: parsed!)
         #expect(components.year == 2024)
         #expect(components.month == 7)
         #expect(components.day == 5)
         #expect(components.hour == 14)
         #expect(components.minute == 3)
         #expect(components.second == 9)
      }
      
      @Test func testStringDateInvalidInputs() {
         #expect("   ".date == nil)
         #expect("2024-02-30T10:20:30".date != nil)
      }
   }
   
   @Suite
   struct StringSearching {
      @Test func testCaseDiacriticComparison() {
         let string1 = "Café"
         let string2 = "CAFE"
         #expect(string1.isCaseAndDiacriticInsensitiveEqual(string2) == true)
         
         let string3 = "hello"
         #expect(string1.isCaseAndDiacriticInsensitiveEqual(string3) == false)
      }
      
      @Test func testContainsText() {
         let string = "Hello World"
         #expect(string.containsText("hello") == true)
         #expect(string.containsText("WORLD") == true)
         #expect(string.containsText("foo") == false)
         #expect(string.containsText(nil) == true)
         #expect(string.containsText("") == true)
         #expect(string.containsText(" ", defaultValue: false) == false)
      }
   }
   
   @Suite
   struct StringSubcripting {
      @Test func testSubscriptAccess() {
         let string = "Hello"
         #expect(string[0...1] == "He")
         #expect(string[1..<4] == "ell")
      }
   }
   
   @Suite
   struct StringValidating {
      @Test func testEmailValid() {
         #expect("john.doe@example.com".isEmailValid == true)
         #expect("üñîçøðé@example.co.uk".isEmailValid == false)
      }
      
      @Test func testEmailInvalid() {
         #expect("plainaddress".isEmailValid == false)
         #expect("@missing.local".isEmailValid == false)
         #expect("bad..dots@example.com".isEmailValid == false)
      }
      
      @Test func testEmailValidationEdgeCases() {
         #expect("  User.Name+tag@EXAMPLE.COM  ".isEmailValid == true)
         #expect("a@b.c".isEmailValid == false)
         #expect("a..b@example.com".isEmailValid == false)
         #expect(".abc@example.com".isEmailValid == false)
         #expect("abc.@example.com".isEmailValid == false)
         #expect("a@b@c.com".isEmailValid == false)
      }
      
      @Test func testHTMLEscape() {
         let html = "<b>Hello & \"you\"</b>"
         let escaped = html.validHTML
         #expect(escaped.contains("&lt;b&gt;"))
         #expect(escaped.contains("&amp;"))
      }

      @Test func testHTMLEscapePreservesEntitiesAndEscapesApostrophe() {
         let html = "Already &lt;safe&gt; & still 'quoted'"
         let escaped = html.validHTML
         #expect(escaped.contains("&lt;safe&gt;"))
         #expect(escaped.contains("&amp; still"))
         #expect(escaped.contains("&#39;quoted&#39;"))
      }
   }
   
   @Suite
   struct Values {
      @Test func testDigitsExtraction() {
         #expect("a1b2c3".digits == "123")
         #expect("123".digits == "123")
         #expect("abc".digits == "")
         #expect("".digits == "")
      }
      
      @Test func testRoundedDecimalRounds() {
         let numberFormatter = NumberFormatter()
         numberFormatter.locale = Locale(identifier: "en_US_POSIX")
         numberFormatter.numberStyle = .decimal
         numberFormatter.minimumFractionDigits = 2
         numberFormatter.maximumFractionDigits = 2
         
         // When parsing a value that should round up on the 3rd decimal
         let input = "12.345"
         let result = input.roundedDecimal(numberFormatter)
         
         // Then expect 12.35 (half-up/plain)
         #expect(result == Decimal(string: "12.35", locale: Locale(identifier: "en_US_POSIX")))
      }
      
      @Test func testRoundedDecimalInvalid() {
         let numberFormatter = NumberFormatter()
         numberFormatter.locale = Locale(identifier: "en_US_POSIX")
         numberFormatter.numberStyle = .decimal
         numberFormatter.minimumFractionDigits = 2
         numberFormatter.maximumFractionDigits = 2
         
         let result = "not-a-number".roundedDecimal(numberFormatter)
         #expect(result == Decimal.zero)
      }
      
      // MARK: - currencyValue / unitPriceValue / twoDecimalsValue
      // These tests use the *same* formatters your production code uses
      // to create a properly localized string, then feed it back to the
      // extension to assert the parsed numeric value.
      //
      // If your NumberFormatter extensions are in another module or have
      // different names, adjust the references below.
      @Test func testCurrencyValue() throws {
         let numberFormatter = NumberFormatter.currencyFormatter
         let number = 1234.567 as NSNumber
         
         // Create a localized string using the *exact* formatter your code will use
         guard let valueString = numberFormatter.string(from: number) else {
            Issue.record("NumberFormatter.currencyFormatter failed to create string")
            return
         }
         
         // Parse via the extension
         let value = valueString.currencyValue
         
         // Expected rounded value according to formatter's rounding rules
         // (usually 2 fraction digits for currency)
         let expected = NSDecimalNumber(decimal: valueString.roundedDecimal(numberFormatter)).doubleValue
         #expect(value == expected)
      }
      
      @Test func testUnitPriceValue() throws {
         let numberFormatter = NumberFormatter.unitPriceFormatter
         let number = 9.994 as NSNumber
         
         guard let valueString = numberFormatter.string(from: number) else {
            Issue.record("NumberFormatter.unitPriceFormatter failed to create string")
            return
         }
         
         let value = valueString.unitPriceValue
         let expected = NSDecimalNumber(decimal: valueString.roundedDecimal(numberFormatter)).doubleValue
         #expect(value == expected)
      }
      
      @Test func testTwoDecimalsValue() throws {
         let numberFormatter = NumberFormatter.twoDecimalsFormatter
         let number = 1.235 as NSNumber
         
         guard let valueString = numberFormatter.string(from: number) else {
            Issue.record("NumberFormatter.twoDecimalsFormatter failed to create string")
            return
         }
         
         let value = valueString.twoDecimalsValue
         let expected = NSDecimalNumber(decimal: valueString.roundedDecimal(numberFormatter)).doubleValue
         #expect(value == expected)
      }
   }
}
