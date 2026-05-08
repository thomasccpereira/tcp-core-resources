import SwiftUI
import PhotosUI
import Foundation

public struct PhotosPickerItemMedia: Sendable {
   public let filename: String
   public let preferredMIMEType: String
   public let mediaData: Data
   
   public init?(item: PhotosPickerItem) async throws {
      guard let filename = item.itemIdentifier?.components(separatedBy: "/").first,
            let preferredMIMEType = item.supportedContentTypes.first?.preferredMIMEType,
            let mediaData = try? await item.loadTransferable(type: Data.self) else { return nil }
      
      self.filename = filename
      self.preferredMIMEType = preferredMIMEType
      self.mediaData = mediaData
   }
}
