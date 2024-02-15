// swiftlint:disable all
import Amplify
import Foundation

public struct Encounter: Model {
  public let id: String
  public var scans: List<Scan>?
  public var vaccines: List<Vaccine>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      scans: List<Scan>? = [],
      vaccines: List<Vaccine>? = []) {
    self.init(id: id,
      scans: scans,
      vaccines: vaccines,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      scans: List<Scan>? = [],
      vaccines: List<Vaccine>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.scans = scans
      self.vaccines = vaccines
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}