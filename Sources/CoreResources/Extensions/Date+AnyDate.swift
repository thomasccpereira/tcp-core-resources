import Foundation

@propertyWrapper
public struct AnyDate: Decodable {
   public var wrappedValue: Date?
   
   public init() throws {
      wrappedValue = nil
   }
   
   public init(dateValue: Date?) throws {
      guard let dateValue else {
         self = try AnyDate()
         return
      }
      
      if dateValue.year > 1900 && dateValue.year < 9999 {
         wrappedValue = dateValue
      }
   }
   
   public init(dateString: String?) throws {
      guard let dateString, !dateString.isEmpty else {
         self = try AnyDate()
         return
      }
      
      guard let date = dateString.date else {
         self = try AnyDate()
         return
      }
      
      try self.init(dateValue: date)
   }
   
   public init<CodingKey>(from values: KeyedDecodingContainer<CodingKey>,
                          key: KeyedDecodingContainer<CodingKey>.Key) throws {
      let dateString = try? values.decode(String.self, forKey: key)
      
      try self.init(dateString: dateString)
   }
   
   public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let dateString = try? container.decode(String.self)
      try self.init(dateString: dateString)
   }
}
