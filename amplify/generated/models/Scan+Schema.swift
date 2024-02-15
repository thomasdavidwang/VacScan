// swiftlint:disable all
import Amplify
import Foundation

extension Scan {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case fileName
    case encounter
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let scan = Scan.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Scans"
    model.syncPluralName = "Scans"
    
    model.attributes(
      .index(fields: ["id"], name: nil),
      .primaryKey(fields: [scan.id])
    )
    
    model.fields(
      .field(scan.id, is: .required, ofType: .string),
      .field(scan.fileName, is: .optional, ofType: .string),
      .belongsTo(scan.encounter, is: .optional, ofType: Encounter.self, targetNames: ["encounterScansId"]),
      .field(scan.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(scan.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Scan: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}