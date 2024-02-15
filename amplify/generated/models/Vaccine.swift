// swiftlint:disable all
import Amplify
import Foundation

public struct Vaccine: Model {
  public let id: String
  public var lotNumber: String?
  public var expirationDate: String?
  public var encounter: Encounter?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      lotNumber: String? = nil,
      expirationDate: String? = nil,
      encounter: Encounter? = nil) {
    self.init(id: id,
      lotNumber: lotNumber,
      expirationDate: expirationDate,
      encounter: encounter,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      lotNumber: String? = nil,
      expirationDate: String? = nil,
      encounter: Encounter? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.lotNumber = lotNumber
      self.expirationDate = expirationDate
      self.encounter = encounter
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}