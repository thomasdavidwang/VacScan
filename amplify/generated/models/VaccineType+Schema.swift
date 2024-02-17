// swiftlint:disable all
import Amplify
import Foundation

extension VaccineType {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let vaccineType = VaccineType.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "VaccineTypes"
    model.syncPluralName = "VaccineTypes"
    
    model.attributes(
      .index(fields: ["id"], name: nil),
      .primaryKey(fields: [vaccineType.id])
    )
    
    model.fields(
      .field(vaccineType.id, is: .required, ofType: .string),
      .field(vaccineType.name, is: .optional, ofType: .string),
      .field(vaccineType.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(vaccineType.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension VaccineType: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}