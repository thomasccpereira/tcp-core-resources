import SwiftUI
import UniformTypeIdentifiers
import Foundation

public extension URL {
   var isDirectory: Bool {
      (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
   }
   
   var isVideo: Bool {
      let mediaExtension = self.pathExtension
      
      guard let uti = UTType(filenameExtension: mediaExtension) else { return false }
      let isVideo = uti.isSubtype(of: .movie) || uti.isSubtype(of: .video)
      return isVideo
   }
}
