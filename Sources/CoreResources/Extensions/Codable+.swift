import Foundation

public extension Encodable {
   var json: String {
      get throws {
         let encoder = JSONEncoder()
         encoder.outputFormatting = .sortedKeys
         
         do {
            let data = try encoder.encode(self)
            return String(decoding: data, as: UTF8.self)
            
         } catch {
            throw error
         }
      }
   }
}
