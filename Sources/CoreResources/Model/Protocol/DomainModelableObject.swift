import Foundation

public protocol DomainModelable {
   associatedtype DomainModel: Sendable
   
   var domainModel: DomainModel { get }
   var essentialDomainModel: DomainModel { get }
}

public extension DomainModelable {
   var essentialDomainModel: DomainModel { domainModel }
}
