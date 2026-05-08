import Foundation

public extension Collection {
   subscript(safe index: Index) -> Element? {
      return indices.contains(index) ? self[index] : nil
   }
}

public extension Array where Element: Equatable {
   mutating func remove(element: Element) {
      if let i = self.firstIndex(of: element) {
         self.remove(at: i)
      }
   }
}

public extension Sequence where Element: Hashable {
   var uniqued: [Element] {
      var set = Set<Element>()
      return filter { set.insert($0).inserted }
   }
}

// MARK: - Concurrency
public extension Sequence where Element: Sendable {
   func asyncForEach(_ operation: (Element) async throws -> Void) async rethrows {
      for element in self {
         try await operation(element)
      }
   }
   
   func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
      var values = [T]()
      
      for element in self {
         try await values.append(transform(element))
      }
      
      return values
   }
   
   func asyncCompactMap<T>(_ transform: (Element) async throws -> T?) async rethrows -> [T] {
      var values = [T]()
      
      for element in self {
         if let value = try await transform(element) {
            values.append(value)
         }
      }
      
      return values
   }
   
   func concurrentForEach(limit: Int = .max,
                          _ operation: @Sendable @escaping (Element) async throws -> Void) async rethrows {
      let items = Array(self)
      guard !items.isEmpty else { return }
      let limit = Swift.max(1, limit)
      
      try await withThrowingTaskGroup(of: Void.self) { group in
         var nextIndex = 0
         
         // Seed first batch
         let initial = Swift.min(limit, items.count)
         for i in 0 ..< initial {
            let element = items[i]
            nextIndex += 1
            
            group.addTask {
               try await operation(element)
            }
         }
         
         // As tasks finish, refill until all are scheduled
         while let _ = try await group.next() {
            if nextIndex < items.count {
               let element = items[nextIndex]
               nextIndex += 1
               
               group.addTask {
                  try await operation(element)
               }
            }
         }
      }
   }
   
   func concurrentMap<T: Sendable>(limit: Int = .max,
                                   _ transform: @Sendable @escaping (Element) async throws -> T) async rethrows -> [T] {
      let items = Array(self)
      guard !items.isEmpty else { return [] }
      let limit = Swift.max(1, limit)
      
      var results = Array<T?>(repeating: nil, count: items.count)
      var nextIndex = 0
      
      try await withThrowingTaskGroup(of: (Int, T).self) { group in
         // Seed the first batch
         let initial = Swift.min(limit, items.count)
         for i in 0..<initial {
            let idx = i
            let element = items[idx]     // capture a single element
            group.addTask {
               (idx, try await transform(element))
            }
         }
         nextIndex = initial
         
         // Refill as tasks finish
         while let (idx, value) = try await group.next() {
            results[idx] = value
            if nextIndex < items.count {
               let idx2 = nextIndex
               let element = items[idx2]
               nextIndex += 1
               group.addTask {
                  (idx2, try await transform(element))
               }
            }
         }
      }
      
      // Safe: all slots are filled before we exit the group
      return results.map { $0! }
   }
   
   func concurrentCompactMap<T: Sendable>(limit: Int = .max,
                                          _ transform: @Sendable @escaping (Element) async throws -> T?) async rethrows -> [T] {
      let items = Array(self)
      guard !items.isEmpty else { return [] }
      let limit = Swift.max(1, limit)
      
      var results = Array<T?>(repeating: nil, count: items.count)
      var nextIndex = 0
      
      try await withThrowingTaskGroup(of: (Int, T?).self) { group in
         // Seed
         let initial = Swift.min(limit, items.count)
         for i in 0..<initial {
            let idx = i
            let element = items[idx]         // capture a single element (Sendable)
            group.addTask { (idx, try await transform(element)) }
         }
         nextIndex = initial
         
         // Refill as tasks complete
         while let (idx, value) = try await group.next() {
            results[idx] = value
            if nextIndex < items.count {
               let idx2 = nextIndex
               let element = items[idx2]
               nextIndex += 1
               group.addTask { (idx2, try await transform(element)) }
            }
         }
      }
      
      // Preserve relative order while dropping nils
      return results.compactMap { $0 }
   }
}
