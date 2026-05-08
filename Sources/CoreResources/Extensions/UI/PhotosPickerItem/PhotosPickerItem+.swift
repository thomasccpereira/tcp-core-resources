import SwiftUI
import PhotosUI

public extension PhotosPickerItem {
   var photoPickerItemMedia: PhotosPickerItemMedia? {
      get async throws {
         try await .init(item: self)
      }
   }
}
