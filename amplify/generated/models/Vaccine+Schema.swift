// swiftlint:disable all
import Amplify
import Foundation

extension Vaccine {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case lotNumber
    case expirationDate
    case encounter
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let vaccine = Vaccine.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Vaccines"
    model.syncPluralName = "Vaccines"
    
    model.attributes(
      .index(fields: ["id"], name: nil),
      .primaryKey(fields: [vaccine.id])
    )
    
    model.fields(
      .field(vaccine.id, is: .required, ofType: .string),
      .field(vaccine.lotNumber, is: .optional, ofType: .string),
      .field(vaccine.expirationDate, is: .optional, ofType: .string),
      .belongsTo(vaccine.encounter, is: .optional, ofType: Encounter.self, targetNames: ["encounterVaccinesId"]),
      .field(vaccine.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(vaccine.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Vaccine: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}