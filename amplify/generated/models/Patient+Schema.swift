// swiftlint:disable all
import Amplify
import Foundation

extension Patient {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case firstName
    case lastName
    case dateOfBirth
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let patient = Patient.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Patients"
    model.syncPluralName = "Patients"
    
    model.attributes(
      .index(fields: ["id"], name: nil),
      .primaryKey(fields: [patient.id])
    )
    
    model.fields(
      .field(patient.id, is: .required, ofType: .string),
      .field(patient.firstName, is: .optional, ofType: .string),
      .field(patient.lastName, is: .optional, ofType: .string),
      .field(patient.dateOfBirth, is: .optional, ofType: .date),
      .field(patient.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(patient.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Patient: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}