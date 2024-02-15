// swiftlint:disable all
import Amplify
import Foundation

public struct Scan: Model {
  public let id: String
  public var fileName: String?
  public var encounter: Encounter?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      fileName: String? = nil,
      encounter: Encounter? = nil) {
    self.init(id: id,
      fileName: fileName,
      encounter: encounter,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      fileName: String? = nil,
      encounter: Encounter? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.fileName = fileName
      self.encounter = encounter
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}