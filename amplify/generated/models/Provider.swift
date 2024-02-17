// swiftlint:disable all
import Amplify
import Foundation

public struct Provider: Model {
  public let id: String
  public var firstName: String?
  public var lastName: String?
  public var phoneNumber: String?
  public var encounters: List<Encounter>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      firstName: String? = nil,
      lastName: String? = nil,
      phoneNumber: String? = nil,
      encounters: List<Encounter>? = []) {
    self.init(id: id,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      encounters: encounters,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      firstName: String? = nil,
      lastName: String? = nil,
      phoneNumber: String? = nil,
      encounters: List<Encounter>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.firstName = firstName
      self.lastName = lastName
      self.phoneNumber = phoneNumber
      self.encounters = encounters
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}