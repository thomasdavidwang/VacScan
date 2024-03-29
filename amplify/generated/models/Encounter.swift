// swiftlint:disable all
import Amplify
import Foundation

public struct Encounter: Model {
  public let id: String
  public var scans: List<Scan>?
  public var vaccines: List<Vaccine>?
  public var provider: Provider?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      scans: List<Scan>? = [],
      vaccines: List<Vaccine>? = [],
      provider: Provider? = nil) {
    self.init(id: id,
      scans: scans,
      vaccines: vaccines,
      provider: provider,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      scans: List<Scan>? = [],
      vaccines: List<Vaccine>? = [],
      provider: Provider? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.scans = scans
      self.vaccines = vaccines
      self.provider = provider
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}