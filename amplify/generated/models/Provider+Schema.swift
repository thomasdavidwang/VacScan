// swiftlint:disable all
import Amplify
import Foundation

extension Provider {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case firstName
    case lastName
    case phoneNumber
    case encounters
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let provider = Provider.keys
    
    model.authRules = [
      rule(allow: .public, provider: .iam, operations: [.read, .create]),
      rule(allow: .private, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Providers"
    model.syncPluralName = "Providers"
    
    model.attributes(
      .index(fields: ["id"], name: nil),
      .primaryKey(fields: [provider.id])
    )
    
    model.fields(
      .field(provider.id, is: .required, ofType: .string),
      .field(provider.firstName, is: .optional, ofType: .string),
      .field(provider.lastName, is: .optional, ofType: .string),
      .field(provider.phoneNumber, is: .optional, ofType: .string),
      .hasMany(provider.encounters, is: .optional, ofType: Encounter.self, associatedWith: Encounter.keys.provider),
      .field(provider.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(provider.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Provider: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}