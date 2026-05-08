import Foundation

public extension Double {
   var integerValue: String {
      let number = NSNumber(value: self)
      return NumberFormatter.integerFormatter.string(from: number) ?? ""
   }
   
   var currencyValue: String {
      let number = NSNumber(value: self)
      return NumberFormatter.currencyFormatter.string(from: number) ?? ""
   }
   
   var unitCurrencyValue: String {
      let number = NSNumber(value: self)
      return NumberFormatter.unitPriceFormatter.string(from: number) ?? ""
   }
   
   var twoDecimals: String {
      let number = NSNumber(value: self)
      return NumberFormatter.twoDecimalsFormatter.string(from: number) ?? "0,00"
   }
   
   var twoDecimalsSync: String {
      let number = NSNumber(value: self)
      return NumberFormatter.twoDecimalsSyncFormatter.string(from: number) ?? "0,00"
   }
   
   var threeDecimals: String {
      let number = NSNumber(value: self)
      return NumberFormatter.threeDecimalsFormatter.string(from: number) ?? "0,000"
   }
   
   var threeDecimalsSync: String {
      let number = NSNumber(value: self)
      return NumberFormatter.threeDecimalsSyncFormatter.string(from: number) ?? "0,000"
   }
   
   var fourDecimals: String {
      let number = NSNumber(value: self)
      return NumberFormatter.fourDecimalsFormatter.string(from: number) ?? "0,0000"
   }
   
   var fourDecimalsSync: String {
      let number = NSNumber(value: self)
      return NumberFormatter.fourDecimalsSyncFormatter.string(from: number) ?? "0,0000"
   }
   
   var percentualTwoDecimals: String { "\(self.twoDecimals)%" }
   
   var percentualThreeDecimals: String { "\(self.threeDecimals)%" }
}
