import Foundation

// MARK: - AnyBool
@propertyWrapper
public struct AnyBool: Decodable {
   public var wrappedValue: Bool
   
   public init(boolValue: Bool) throws {
      wrappedValue = boolValue
   }
   
   public init(stringValue: String?) throws {
      switch stringValue {
      case "true", "1", "yes", "y": wrappedValue = true
      default: wrappedValue = false
      }
   }
   
   public init<CodingKey>(from values: KeyedDecodingContainer<CodingKey>,
                          key: KeyedDecodingContainer<CodingKey>.Key,
                          defaultValue: Bool = false) throws {
      // String
      if let boolString = try? values.decode(String.self, forKey: key) {
         wrappedValue = try AnyBool(stringValue: boolString).wrappedValue
         
      } else if let boolInt  = try? values.decode(Int.self, forKey: key) {
         wrappedValue = NSNumber(integerLiteral: boolInt).boolValue
         
      } else if let bool = try? values.decode(Bool.self, forKey: key) {
         wrappedValue = bool
         
      } else {
         wrappedValue = defaultValue
      }
   }
   
   public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      
      // String
      if let boolString = try? container.decode(String.self) {
         wrappedValue = try AnyBool(stringValue: boolString).wrappedValue
         
      } else if let boolInt  = try? container.decode(Int.self) {
         wrappedValue = NSNumber(integerLiteral: boolInt).boolValue
         
      } else if let bool = try? container.decode(Bool.self) {
         wrappedValue = bool
         
      } else {
         wrappedValue = false
      }
   }
}
