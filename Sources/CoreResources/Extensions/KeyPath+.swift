import Foundation

public extension PartialKeyPath {
   var partialPathName: String {
      let me = String(describing: self)
      let dropLeading =  "\\" + String(describing: Root.self) + "."
      let keyPath = "\(me.dropFirst(dropLeading.count))"
      return keyPath
   }
}

public extension KeyPath {
   var pathName: String {
      "\(self)".components(separatedBy: ".").last ?? ""
   }
}

public extension Sequence {
   func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
      return map { $0[keyPath: keyPath] }
   }
   
   func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
      return sorted { a, b in
         return a[keyPath: keyPath] < b[keyPath: keyPath]
      }
   }
}

public prefix func !<Root>(keyPath: KeyPath<Root, Bool>) -> (Root) -> Bool {
   return { !$0[keyPath: keyPath] }
}

public func == <Root, Value: Equatable>(lhs: KeyPath<Root, Value>,
                                        rhs: Value) -> (Root) -> Bool {
   return { $0[keyPath: lhs] == rhs }
}

public func != <Root, Value: Equatable>(lhs: KeyPath<Root, Value>,
                                        rhs: Value) -> (Root) -> Bool {
   { $0[keyPath: lhs] != rhs }
}

public func < <Root, Value: Comparable>(lhs: KeyPath<Root, Value>,
                                        rhs: Value) -> (Root) -> Bool {
   { $0[keyPath: lhs] < rhs }
}
