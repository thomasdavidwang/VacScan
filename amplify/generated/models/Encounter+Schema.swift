// swiftlint:disable all
import Amplify
import Foundation

extension Encounter {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case scans
    case vaccines
    case provider
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let encounter = Encounter.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Encounters"
    model.syncPluralName = "Encounters"
    
    model.attributes(
      .index(fields: ["id"], name: nil),
      .primaryKey(fields: [encounter.id])
    )
    
    model.fields(
      .field(encounter.id, is: .required, ofType: .string),
      .hasMany(encounter.scans, is: .optional, ofType: Scan.self, associatedWith: Scan.keys.encounter),
      .hasMany(encounter.vaccines, is: .optional, ofType: Vaccine.self, associatedWith: Vaccine.keys.encounter),
      .belongsTo(encounter.provider, is: .optional, ofType: Provider.self, targetNames: ["providerEncountersId"]),
      .field(encounter.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(encounter.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Encounter: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}