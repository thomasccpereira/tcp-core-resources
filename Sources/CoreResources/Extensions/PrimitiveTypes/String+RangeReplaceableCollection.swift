import Foundation

extension RangeReplaceableCollection where Self: StringProtocol {
   public var digits: Self { filter(\.isWholeNumber) }
}
