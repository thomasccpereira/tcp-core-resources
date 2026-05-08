import SwiftUI
import Foundation

public extension View {
   func border(width: CGFloat = 1.0, edges: [Edge] = [.top, .leading, .trailing, .bottom], color: Color) -> some View {
      overlay(ViewBorder(width: width, edges: edges).foregroundColor(color))
   }
   
   func border(width: CGFloat = 1.0, axis: Axis, color: Color) -> some View {
      switch axis {
      case .horizontal:
         overlay(ViewBorder(width: width, edges: [.leading, .trailing]).foregroundColor(color))
         
      case .vertical:
         overlay(ViewBorder(width: width, edges: [.top, .bottom]).foregroundColor(color))
      }
   }
}

fileprivate struct ViewBorder: Shape {
   var width: CGFloat
   var edges: [Edge]
   
   func path(in rect: CGRect) -> Path {
      edges.map { edge -> Path in
         switch edge {
         case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
         case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
         case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
         case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
         }
      }.reduce(into: Path()) { $0.addPath($1) }
   }
}
