// swiftlint:disable all
import Amplify
import Foundation

public struct Patient: Model {
  public let id: String
  public var firstName: String?
  public var lastName: String?
  public var dateOfBirth: Temporal.Date?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      firstName: String? = nil,
      lastName: String? = nil,
      dateOfBirth: Temporal.Date? = nil) {
    self.init(id: id,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      firstName: String? = nil,
      lastName: String? = nil,
      dateOfBirth: Temporal.Date? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.firstName = firstName
      self.lastName = lastName
      self.dateOfBirth = dateOfBirth
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}