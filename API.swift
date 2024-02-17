//  This file was automatically generated and should not be edited.

#if canImport(AWSAPIPlugin)
import Foundation

public protocol GraphQLInputValue {
}

public struct GraphQLVariable {
  let name: String
  
  public init(_ name: String) {
    self.name = name
  }
}

extension GraphQLVariable: GraphQLInputValue {
}

extension JSONEncodable {
  public func evaluate(with variables: [String: JSONEncodable]?) throws -> Any {
    return jsonValue
  }
}

public typealias GraphQLMap = [String: JSONEncodable?]

extension Dictionary where Key == String, Value == JSONEncodable? {
  public var withNilValuesRemoved: Dictionary<String, JSONEncodable> {
    var filtered = Dictionary<String, JSONEncodable>(minimumCapacity: count)
    for (key, value) in self {
      if value != nil {
        filtered[key] = value
      }
    }
    return filtered
  }
}

public protocol GraphQLMapConvertible: JSONEncodable {
  var graphQLMap: GraphQLMap { get }
}

public extension GraphQLMapConvertible {
  var jsonValue: Any {
    return graphQLMap.withNilValuesRemoved.jsonValue
  }
}

public typealias GraphQLID = String

public protocol APISwiftGraphQLOperation: AnyObject {
  
  static var operationString: String { get }
  static var requestString: String { get }
  static var operationIdentifier: String? { get }
  
  var variables: GraphQLMap? { get }
  
  associatedtype Data: GraphQLSelectionSet
}

public extension APISwiftGraphQLOperation {
  static var requestString: String {
    return operationString
  }

  static var operationIdentifier: String? {
    return nil
  }

  var variables: GraphQLMap? {
    return nil
  }
}

public protocol GraphQLQuery: APISwiftGraphQLOperation {}

public protocol GraphQLMutation: APISwiftGraphQLOperation {}

public protocol GraphQLSubscription: APISwiftGraphQLOperation {}

public protocol GraphQLFragment: GraphQLSelectionSet {
  static var possibleTypes: [String] { get }
}

public typealias Snapshot = [String: Any?]

public protocol GraphQLSelectionSet: Decodable {
  static var selections: [GraphQLSelection] { get }
  
  var snapshot: Snapshot { get }
  init(snapshot: Snapshot)
}

extension GraphQLSelectionSet {
    public init(from decoder: Decoder) throws {
        if let jsonObject = try? APISwiftJSONValue(from: decoder) {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(jsonObject)
            let decodedDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            let optionalDictionary = decodedDictionary.mapValues { $0 as Any? }

            self.init(snapshot: optionalDictionary)
        } else {
            self.init(snapshot: [:])
        }
    }
}

enum APISwiftJSONValue: Codable {
    case array([APISwiftJSONValue])
    case boolean(Bool)
    case number(Double)
    case object([String: APISwiftJSONValue])
    case string(String)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode([String: APISwiftJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([APISwiftJSONValue].self) {
            self = .array(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            self = .null
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .array(let value):
            try container.encode(value)
        case .boolean(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

public protocol GraphQLSelection {
}

public struct GraphQLField: GraphQLSelection {
  let name: String
  let alias: String?
  let arguments: [String: GraphQLInputValue]?
  
  var responseKey: String {
    return alias ?? name
  }
  
  let type: GraphQLOutputType
  
  public init(_ name: String, alias: String? = nil, arguments: [String: GraphQLInputValue]? = nil, type: GraphQLOutputType) {
    self.name = name
    self.alias = alias
    
    self.arguments = arguments
    
    self.type = type
  }
}

public indirect enum GraphQLOutputType {
  case scalar(JSONDecodable.Type)
  case object([GraphQLSelection])
  case nonNull(GraphQLOutputType)
  case list(GraphQLOutputType)
  
  var namedType: GraphQLOutputType {
    switch self {
    case .nonNull(let innerType), .list(let innerType):
      return innerType.namedType
    case .scalar, .object:
      return self
    }
  }
}

public struct GraphQLBooleanCondition: GraphQLSelection {
  let variableName: String
  let inverted: Bool
  let selections: [GraphQLSelection]
  
  public init(variableName: String, inverted: Bool, selections: [GraphQLSelection]) {
    self.variableName = variableName
    self.inverted = inverted;
    self.selections = selections;
  }
}

public struct GraphQLTypeCondition: GraphQLSelection {
  let possibleTypes: [String]
  let selections: [GraphQLSelection]
  
  public init(possibleTypes: [String], selections: [GraphQLSelection]) {
    self.possibleTypes = possibleTypes
    self.selections = selections;
  }
}

public struct GraphQLFragmentSpread: GraphQLSelection {
  let fragment: GraphQLFragment.Type
  
  public init(_ fragment: GraphQLFragment.Type) {
    self.fragment = fragment
  }
}

public struct GraphQLTypeCase: GraphQLSelection {
  let variants: [String: [GraphQLSelection]]
  let `default`: [GraphQLSelection]
  
  public init(variants: [String: [GraphQLSelection]], default: [GraphQLSelection]) {
    self.variants = variants
    self.default = `default`;
  }
}

public typealias JSONObject = [String: Any]

public protocol JSONDecodable {
  init(jsonValue value: Any) throws
}

public protocol JSONEncodable: GraphQLInputValue {
  var jsonValue: Any { get }
}

public enum JSONDecodingError: Error, LocalizedError {
  case missingValue
  case nullValue
  case wrongType
  case couldNotConvert(value: Any, to: Any.Type)
  
  public var errorDescription: String? {
    switch self {
    case .missingValue:
      return "Missing value"
    case .nullValue:
      return "Unexpected null value"
    case .wrongType:
      return "Wrong type"
    case .couldNotConvert(let value, let expectedType):
      return "Could not convert \"\(value)\" to \(expectedType)"
    }
  }
}

extension String: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }
    self = string
  }

  public var jsonValue: Any {
    return self
  }
}

extension Int: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Int.self)
    }
    self = number.intValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Float: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Float.self)
    }
    self = number.floatValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Double: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Double.self)
    }
    self = number.doubleValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Bool: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let bool = value as? Bool else {
        throw JSONDecodingError.couldNotConvert(value: value, to: Bool.self)
    }
    self = bool
  }

  public var jsonValue: Any {
    return self
  }
}

extension RawRepresentable where RawValue: JSONDecodable {
  public init(jsonValue value: Any) throws {
    let rawValue = try RawValue(jsonValue: value)
    if let tempSelf = Self(rawValue: rawValue) {
      self = tempSelf
    } else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Self.self)
    }
  }
}

extension RawRepresentable where RawValue: JSONEncodable {
  public var jsonValue: Any {
    return rawValue.jsonValue
  }
}

extension Optional where Wrapped: JSONDecodable {
  public init(jsonValue value: Any) throws {
    if value is NSNull {
      self = .none
    } else {
      self = .some(try Wrapped(jsonValue: value))
    }
  }
}

extension Optional: JSONEncodable {
  public var jsonValue: Any {
    switch self {
    case .none:
      return NSNull()
    case .some(let wrapped as JSONEncodable):
      return wrapped.jsonValue
    default:
      fatalError("Optional is only JSONEncodable if Wrapped is")
    }
  }
}

extension Dictionary: JSONEncodable {
  public var jsonValue: Any {
    return jsonObject
  }
  
  public var jsonObject: JSONObject {
    var jsonObject = JSONObject(minimumCapacity: count)
    for (key, value) in self {
      if case let (key as String, value as JSONEncodable) = (key, value) {
        jsonObject[key] = value.jsonValue
      } else {
        fatalError("Dictionary is only JSONEncodable if Value is (and if Key is String)")
      }
    }
    return jsonObject
  }
}

extension Array: JSONEncodable {
  public var jsonValue: Any {
    return map() { element -> (Any) in
      if case let element as JSONEncodable = element {
        return element.jsonValue
      } else {
        fatalError("Array is only JSONEncodable if Element is")
      }
    }
  }
}

extension URL: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: URL.self)
    }
    self.init(string: string)!
  }

  public var jsonValue: Any {
    return self.absoluteString
  }
}

extension Dictionary {
  static func += (lhs: inout Dictionary, rhs: Dictionary) {
    lhs.merge(rhs) { (_, new) in new }
  }
}

#elseif canImport(AWSAppSync)
import AWSAppSync
#endif

public struct CreatePatientInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, firstName: String? = nil, lastName: String? = nil, dateOfBirth: String? = nil) {
    graphQLMap = ["id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var firstName: String? {
    get {
      return graphQLMap["firstName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: String? {
    get {
      return graphQLMap["lastName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var dateOfBirth: String? {
    get {
      return graphQLMap["dateOfBirth"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateOfBirth")
    }
  }
}

public struct ModelPatientConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(firstName: ModelStringInput? = nil, lastName: ModelStringInput? = nil, dateOfBirth: ModelStringInput? = nil, and: [ModelPatientConditionInput?]? = nil, or: [ModelPatientConditionInput?]? = nil, not: ModelPatientConditionInput? = nil) {
    graphQLMap = ["firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "and": and, "or": or, "not": not]
  }

  public var firstName: ModelStringInput? {
    get {
      return graphQLMap["firstName"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: ModelStringInput? {
    get {
      return graphQLMap["lastName"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var dateOfBirth: ModelStringInput? {
    get {
      return graphQLMap["dateOfBirth"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateOfBirth")
    }
  }

  public var and: [ModelPatientConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelPatientConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelPatientConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelPatientConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelPatientConditionInput? {
    get {
      return graphQLMap["not"] as! ModelPatientConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public enum ModelAttributeTypes: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case binary
  case binarySet
  case bool
  case list
  case map
  case number
  case numberSet
  case string
  case stringSet
  case null
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "binary": self = .binary
      case "binarySet": self = .binarySet
      case "bool": self = .bool
      case "list": self = .list
      case "map": self = .map
      case "number": self = .number
      case "numberSet": self = .numberSet
      case "string": self = .string
      case "stringSet": self = .stringSet
      case "_null": self = .null
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .binary: return "binary"
      case .binarySet: return "binarySet"
      case .bool: return "bool"
      case .list: return "list"
      case .map: return "map"
      case .number: return "number"
      case .numberSet: return "numberSet"
      case .string: return "string"
      case .stringSet: return "stringSet"
      case .null: return "_null"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelAttributeTypes, rhs: ModelAttributeTypes) -> Bool {
    switch (lhs, rhs) {
      case (.binary, .binary): return true
      case (.binarySet, .binarySet): return true
      case (.bool, .bool): return true
      case (.list, .list): return true
      case (.map, .map): return true
      case (.number, .number): return true
      case (.numberSet, .numberSet): return true
      case (.string, .string): return true
      case (.stringSet, .stringSet): return true
      case (.null, .null): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelSizeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

public struct UpdatePatientInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, dateOfBirth: String? = nil) {
    graphQLMap = ["id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var firstName: String? {
    get {
      return graphQLMap["firstName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: String? {
    get {
      return graphQLMap["lastName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var dateOfBirth: String? {
    get {
      return graphQLMap["dateOfBirth"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateOfBirth")
    }
  }
}

public struct DeletePatientInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateProviderInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil) {
    graphQLMap = ["id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var firstName: String? {
    get {
      return graphQLMap["firstName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: String? {
    get {
      return graphQLMap["lastName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var phoneNumber: String? {
    get {
      return graphQLMap["phoneNumber"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }
}

public struct ModelProviderConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(firstName: ModelStringInput? = nil, lastName: ModelStringInput? = nil, phoneNumber: ModelStringInput? = nil, and: [ModelProviderConditionInput?]? = nil, or: [ModelProviderConditionInput?]? = nil, not: ModelProviderConditionInput? = nil) {
    graphQLMap = ["firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "and": and, "or": or, "not": not]
  }

  public var firstName: ModelStringInput? {
    get {
      return graphQLMap["firstName"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: ModelStringInput? {
    get {
      return graphQLMap["lastName"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var phoneNumber: ModelStringInput? {
    get {
      return graphQLMap["phoneNumber"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var and: [ModelProviderConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelProviderConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelProviderConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelProviderConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelProviderConditionInput? {
    get {
      return graphQLMap["not"] as! ModelProviderConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateProviderInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil) {
    graphQLMap = ["id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var firstName: String? {
    get {
      return graphQLMap["firstName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: String? {
    get {
      return graphQLMap["lastName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var phoneNumber: String? {
    get {
      return graphQLMap["phoneNumber"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }
}

public struct DeleteProviderInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateEncounterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, providerEncountersId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "providerEncountersId": providerEncountersId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var providerEncountersId: GraphQLID? {
    get {
      return graphQLMap["providerEncountersId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "providerEncountersId")
    }
  }
}

public struct ModelEncounterConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(and: [ModelEncounterConditionInput?]? = nil, or: [ModelEncounterConditionInput?]? = nil, not: ModelEncounterConditionInput? = nil, providerEncountersId: ModelIDInput? = nil) {
    graphQLMap = ["and": and, "or": or, "not": not, "providerEncountersId": providerEncountersId]
  }

  public var and: [ModelEncounterConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelEncounterConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelEncounterConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelEncounterConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelEncounterConditionInput? {
    get {
      return graphQLMap["not"] as! ModelEncounterConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var providerEncountersId: ModelIDInput? {
    get {
      return graphQLMap["providerEncountersId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "providerEncountersId")
    }
  }
}

public struct ModelIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public struct UpdateEncounterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, providerEncountersId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "providerEncountersId": providerEncountersId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var providerEncountersId: GraphQLID? {
    get {
      return graphQLMap["providerEncountersId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "providerEncountersId")
    }
  }
}

public struct DeleteEncounterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateVaccineInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, lotNumber: String? = nil, expirationDate: String? = nil, encounterVaccinesId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "encounterVaccinesId": encounterVaccinesId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var lotNumber: String? {
    get {
      return graphQLMap["lotNumber"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lotNumber")
    }
  }

  public var expirationDate: String? {
    get {
      return graphQLMap["expirationDate"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "expirationDate")
    }
  }

  public var encounterVaccinesId: GraphQLID? {
    get {
      return graphQLMap["encounterVaccinesId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "encounterVaccinesId")
    }
  }
}

public struct ModelVaccineConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(lotNumber: ModelStringInput? = nil, expirationDate: ModelStringInput? = nil, and: [ModelVaccineConditionInput?]? = nil, or: [ModelVaccineConditionInput?]? = nil, not: ModelVaccineConditionInput? = nil, encounterVaccinesId: ModelIDInput? = nil) {
    graphQLMap = ["lotNumber": lotNumber, "expirationDate": expirationDate, "and": and, "or": or, "not": not, "encounterVaccinesId": encounterVaccinesId]
  }

  public var lotNumber: ModelStringInput? {
    get {
      return graphQLMap["lotNumber"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lotNumber")
    }
  }

  public var expirationDate: ModelStringInput? {
    get {
      return graphQLMap["expirationDate"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "expirationDate")
    }
  }

  public var and: [ModelVaccineConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelVaccineConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelVaccineConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelVaccineConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelVaccineConditionInput? {
    get {
      return graphQLMap["not"] as! ModelVaccineConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var encounterVaccinesId: ModelIDInput? {
    get {
      return graphQLMap["encounterVaccinesId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "encounterVaccinesId")
    }
  }
}

public struct UpdateVaccineInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, lotNumber: String? = nil, expirationDate: String? = nil, encounterVaccinesId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "encounterVaccinesId": encounterVaccinesId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var lotNumber: String? {
    get {
      return graphQLMap["lotNumber"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lotNumber")
    }
  }

  public var expirationDate: String? {
    get {
      return graphQLMap["expirationDate"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "expirationDate")
    }
  }

  public var encounterVaccinesId: GraphQLID? {
    get {
      return graphQLMap["encounterVaccinesId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "encounterVaccinesId")
    }
  }
}

public struct DeleteVaccineInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateVaccineTypeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, name: String? = nil) {
    graphQLMap = ["id": id, "name": name]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return graphQLMap["name"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }
}

public struct ModelVaccineTypeConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: ModelStringInput? = nil, and: [ModelVaccineTypeConditionInput?]? = nil, or: [ModelVaccineTypeConditionInput?]? = nil, not: ModelVaccineTypeConditionInput? = nil) {
    graphQLMap = ["name": name, "and": and, "or": or, "not": not]
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var and: [ModelVaccineTypeConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelVaccineTypeConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelVaccineTypeConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelVaccineTypeConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelVaccineTypeConditionInput? {
    get {
      return graphQLMap["not"] as! ModelVaccineTypeConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateVaccineTypeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, name: String? = nil) {
    graphQLMap = ["id": id, "name": name]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return graphQLMap["name"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }
}

public struct DeleteVaccineTypeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateScanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, fileName: String? = nil, encounterScansId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "fileName": fileName, "encounterScansId": encounterScansId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var fileName: String? {
    get {
      return graphQLMap["fileName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fileName")
    }
  }

  public var encounterScansId: GraphQLID? {
    get {
      return graphQLMap["encounterScansId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "encounterScansId")
    }
  }
}

public struct ModelScanConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(fileName: ModelStringInput? = nil, and: [ModelScanConditionInput?]? = nil, or: [ModelScanConditionInput?]? = nil, not: ModelScanConditionInput? = nil, encounterScansId: ModelIDInput? = nil) {
    graphQLMap = ["fileName": fileName, "and": and, "or": or, "not": not, "encounterScansId": encounterScansId]
  }

  public var fileName: ModelStringInput? {
    get {
      return graphQLMap["fileName"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fileName")
    }
  }

  public var and: [ModelScanConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelScanConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelScanConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelScanConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelScanConditionInput? {
    get {
      return graphQLMap["not"] as! ModelScanConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var encounterScansId: ModelIDInput? {
    get {
      return graphQLMap["encounterScansId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "encounterScansId")
    }
  }
}

public struct UpdateScanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, fileName: String? = nil, encounterScansId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "fileName": fileName, "encounterScansId": encounterScansId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var fileName: String? {
    get {
      return graphQLMap["fileName"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fileName")
    }
  }

  public var encounterScansId: GraphQLID? {
    get {
      return graphQLMap["encounterScansId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "encounterScansId")
    }
  }
}

public struct DeleteScanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct ModelPatientFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, firstName: ModelStringInput? = nil, lastName: ModelStringInput? = nil, dateOfBirth: ModelStringInput? = nil, and: [ModelPatientFilterInput?]? = nil, or: [ModelPatientFilterInput?]? = nil, not: ModelPatientFilterInput? = nil) {
    graphQLMap = ["id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var firstName: ModelStringInput? {
    get {
      return graphQLMap["firstName"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: ModelStringInput? {
    get {
      return graphQLMap["lastName"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var dateOfBirth: ModelStringInput? {
    get {
      return graphQLMap["dateOfBirth"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateOfBirth")
    }
  }

  public var and: [ModelPatientFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelPatientFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelPatientFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelPatientFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelPatientFilterInput? {
    get {
      return graphQLMap["not"] as! ModelPatientFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public enum ModelSortDirection: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case asc
  case desc
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ASC": self = .asc
      case "DESC": self = .desc
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .asc: return "ASC"
      case .desc: return "DESC"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelSortDirection, rhs: ModelSortDirection) -> Bool {
    switch (lhs, rhs) {
      case (.asc, .asc): return true
      case (.desc, .desc): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelProviderFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, firstName: ModelStringInput? = nil, lastName: ModelStringInput? = nil, phoneNumber: ModelStringInput? = nil, and: [ModelProviderFilterInput?]? = nil, or: [ModelProviderFilterInput?]? = nil, not: ModelProviderFilterInput? = nil) {
    graphQLMap = ["id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var firstName: ModelStringInput? {
    get {
      return graphQLMap["firstName"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: ModelStringInput? {
    get {
      return graphQLMap["lastName"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var phoneNumber: ModelStringInput? {
    get {
      return graphQLMap["phoneNumber"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var and: [ModelProviderFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelProviderFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelProviderFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelProviderFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelProviderFilterInput? {
    get {
      return graphQLMap["not"] as! ModelProviderFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelEncounterFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, and: [ModelEncounterFilterInput?]? = nil, or: [ModelEncounterFilterInput?]? = nil, not: ModelEncounterFilterInput? = nil, providerEncountersId: ModelIDInput? = nil) {
    graphQLMap = ["id": id, "and": and, "or": or, "not": not, "providerEncountersId": providerEncountersId]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var and: [ModelEncounterFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelEncounterFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelEncounterFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelEncounterFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelEncounterFilterInput? {
    get {
      return graphQLMap["not"] as! ModelEncounterFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var providerEncountersId: ModelIDInput? {
    get {
      return graphQLMap["providerEncountersId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "providerEncountersId")
    }
  }
}

public struct ModelVaccineFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, lotNumber: ModelStringInput? = nil, expirationDate: ModelStringInput? = nil, and: [ModelVaccineFilterInput?]? = nil, or: [ModelVaccineFilterInput?]? = nil, not: ModelVaccineFilterInput? = nil, encounterVaccinesId: ModelIDInput? = nil) {
    graphQLMap = ["id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "and": and, "or": or, "not": not, "encounterVaccinesId": encounterVaccinesId]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var lotNumber: ModelStringInput? {
    get {
      return graphQLMap["lotNumber"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lotNumber")
    }
  }

  public var expirationDate: ModelStringInput? {
    get {
      return graphQLMap["expirationDate"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "expirationDate")
    }
  }

  public var and: [ModelVaccineFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelVaccineFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelVaccineFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelVaccineFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelVaccineFilterInput? {
    get {
      return graphQLMap["not"] as! ModelVaccineFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var encounterVaccinesId: ModelIDInput? {
    get {
      return graphQLMap["encounterVaccinesId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "encounterVaccinesId")
    }
  }
}

public struct ModelVaccineTypeFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, name: ModelStringInput? = nil, and: [ModelVaccineTypeFilterInput?]? = nil, or: [ModelVaccineTypeFilterInput?]? = nil, not: ModelVaccineTypeFilterInput? = nil) {
    graphQLMap = ["id": id, "name": name, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var and: [ModelVaccineTypeFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelVaccineTypeFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelVaccineTypeFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelVaccineTypeFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelVaccineTypeFilterInput? {
    get {
      return graphQLMap["not"] as! ModelVaccineTypeFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelScanFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, fileName: ModelStringInput? = nil, and: [ModelScanFilterInput?]? = nil, or: [ModelScanFilterInput?]? = nil, not: ModelScanFilterInput? = nil, encounterScansId: ModelIDInput? = nil) {
    graphQLMap = ["id": id, "fileName": fileName, "and": and, "or": or, "not": not, "encounterScansId": encounterScansId]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var fileName: ModelStringInput? {
    get {
      return graphQLMap["fileName"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fileName")
    }
  }

  public var and: [ModelScanFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelScanFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelScanFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelScanFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelScanFilterInput? {
    get {
      return graphQLMap["not"] as! ModelScanFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var encounterScansId: ModelIDInput? {
    get {
      return graphQLMap["encounterScansId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "encounterScansId")
    }
  }
}

public struct ModelSubscriptionPatientFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, firstName: ModelSubscriptionStringInput? = nil, lastName: ModelSubscriptionStringInput? = nil, dateOfBirth: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionPatientFilterInput?]? = nil, or: [ModelSubscriptionPatientFilterInput?]? = nil) {
    graphQLMap = ["id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var firstName: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["firstName"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["lastName"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var dateOfBirth: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["dateOfBirth"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateOfBirth")
    }
  }

  public var and: [ModelSubscriptionPatientFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionPatientFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionPatientFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionPatientFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [GraphQLID?]? {
    get {
      return graphQLMap["in"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [GraphQLID?]? {
    get {
      return graphQLMap["notIn"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [String?]? {
    get {
      return graphQLMap["in"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [String?]? {
    get {
      return graphQLMap["notIn"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionProviderFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, firstName: ModelSubscriptionStringInput? = nil, lastName: ModelSubscriptionStringInput? = nil, phoneNumber: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionProviderFilterInput?]? = nil, or: [ModelSubscriptionProviderFilterInput?]? = nil) {
    graphQLMap = ["id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var firstName: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["firstName"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["lastName"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var phoneNumber: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["phoneNumber"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var and: [ModelSubscriptionProviderFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionProviderFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionProviderFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionProviderFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionEncounterFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, and: [ModelSubscriptionEncounterFilterInput?]? = nil, or: [ModelSubscriptionEncounterFilterInput?]? = nil) {
    graphQLMap = ["id": id, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var and: [ModelSubscriptionEncounterFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionEncounterFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionEncounterFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionEncounterFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionVaccineFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, lotNumber: ModelSubscriptionStringInput? = nil, expirationDate: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionVaccineFilterInput?]? = nil, or: [ModelSubscriptionVaccineFilterInput?]? = nil) {
    graphQLMap = ["id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var lotNumber: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["lotNumber"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lotNumber")
    }
  }

  public var expirationDate: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["expirationDate"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "expirationDate")
    }
  }

  public var and: [ModelSubscriptionVaccineFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionVaccineFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionVaccineFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionVaccineFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionVaccineTypeFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, name: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionVaccineTypeFilterInput?]? = nil, or: [ModelSubscriptionVaccineTypeFilterInput?]? = nil) {
    graphQLMap = ["id": id, "name": name, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["name"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var and: [ModelSubscriptionVaccineTypeFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionVaccineTypeFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionVaccineTypeFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionVaccineTypeFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionScanFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, fileName: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionScanFilterInput?]? = nil, or: [ModelSubscriptionScanFilterInput?]? = nil) {
    graphQLMap = ["id": id, "fileName": fileName, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var fileName: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["fileName"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fileName")
    }
  }

  public var and: [ModelSubscriptionScanFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionScanFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionScanFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionScanFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public final class CreatePatientMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreatePatient($input: CreatePatientInput!, $condition: ModelPatientConditionInput) {\n  createPatient(input: $input, condition: $condition) {\n    __typename\n    id\n    firstName\n    lastName\n    dateOfBirth\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreatePatientInput
  public var condition: ModelPatientConditionInput?

  public init(input: CreatePatientInput, condition: ModelPatientConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createPatient", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreatePatient.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createPatient: CreatePatient? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createPatient": createPatient.flatMap { $0.snapshot }])
    }

    public var createPatient: CreatePatient? {
      get {
        return (snapshot["createPatient"] as? Snapshot).flatMap { CreatePatient(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createPatient")
      }
    }

    public struct CreatePatient: GraphQLSelectionSet {
      public static let possibleTypes = ["Patient"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("dateOfBirth", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, dateOfBirth: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Patient", "id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var dateOfBirth: String? {
        get {
          return snapshot["dateOfBirth"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateOfBirth")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class UpdatePatientMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdatePatient($input: UpdatePatientInput!, $condition: ModelPatientConditionInput) {\n  updatePatient(input: $input, condition: $condition) {\n    __typename\n    id\n    firstName\n    lastName\n    dateOfBirth\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdatePatientInput
  public var condition: ModelPatientConditionInput?

  public init(input: UpdatePatientInput, condition: ModelPatientConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updatePatient", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdatePatient.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updatePatient: UpdatePatient? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updatePatient": updatePatient.flatMap { $0.snapshot }])
    }

    public var updatePatient: UpdatePatient? {
      get {
        return (snapshot["updatePatient"] as? Snapshot).flatMap { UpdatePatient(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updatePatient")
      }
    }

    public struct UpdatePatient: GraphQLSelectionSet {
      public static let possibleTypes = ["Patient"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("dateOfBirth", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, dateOfBirth: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Patient", "id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var dateOfBirth: String? {
        get {
          return snapshot["dateOfBirth"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateOfBirth")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class DeletePatientMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeletePatient($input: DeletePatientInput!, $condition: ModelPatientConditionInput) {\n  deletePatient(input: $input, condition: $condition) {\n    __typename\n    id\n    firstName\n    lastName\n    dateOfBirth\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeletePatientInput
  public var condition: ModelPatientConditionInput?

  public init(input: DeletePatientInput, condition: ModelPatientConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deletePatient", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeletePatient.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deletePatient: DeletePatient? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deletePatient": deletePatient.flatMap { $0.snapshot }])
    }

    public var deletePatient: DeletePatient? {
      get {
        return (snapshot["deletePatient"] as? Snapshot).flatMap { DeletePatient(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deletePatient")
      }
    }

    public struct DeletePatient: GraphQLSelectionSet {
      public static let possibleTypes = ["Patient"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("dateOfBirth", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, dateOfBirth: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Patient", "id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var dateOfBirth: String? {
        get {
          return snapshot["dateOfBirth"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateOfBirth")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class CreateProviderMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateProvider($input: CreateProviderInput!, $condition: ModelProviderConditionInput) {\n  createProvider(input: $input, condition: $condition) {\n    __typename\n    id\n    firstName\n    lastName\n    phoneNumber\n    encounters {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateProviderInput
  public var condition: ModelProviderConditionInput?

  public init(input: CreateProviderInput, condition: ModelProviderConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createProvider", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateProvider.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createProvider: CreateProvider? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createProvider": createProvider.flatMap { $0.snapshot }])
    }

    public var createProvider: CreateProvider? {
      get {
        return (snapshot["createProvider"] as? Snapshot).flatMap { CreateProvider(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createProvider")
      }
    }

    public struct CreateProvider: GraphQLSelectionSet {
      public static let possibleTypes = ["Provider"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("phoneNumber", type: .scalar(String.self)),
        GraphQLField("encounters", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, encounters: Encounter? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "encounters": encounters.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var phoneNumber: String? {
        get {
          return snapshot["phoneNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var encounters: Encounter? {
        get {
          return (snapshot["encounters"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounters")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelEncounterConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelEncounterConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class UpdateProviderMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateProvider($input: UpdateProviderInput!, $condition: ModelProviderConditionInput) {\n  updateProvider(input: $input, condition: $condition) {\n    __typename\n    id\n    firstName\n    lastName\n    phoneNumber\n    encounters {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateProviderInput
  public var condition: ModelProviderConditionInput?

  public init(input: UpdateProviderInput, condition: ModelProviderConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateProvider", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateProvider.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateProvider: UpdateProvider? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateProvider": updateProvider.flatMap { $0.snapshot }])
    }

    public var updateProvider: UpdateProvider? {
      get {
        return (snapshot["updateProvider"] as? Snapshot).flatMap { UpdateProvider(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateProvider")
      }
    }

    public struct UpdateProvider: GraphQLSelectionSet {
      public static let possibleTypes = ["Provider"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("phoneNumber", type: .scalar(String.self)),
        GraphQLField("encounters", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, encounters: Encounter? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "encounters": encounters.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var phoneNumber: String? {
        get {
          return snapshot["phoneNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var encounters: Encounter? {
        get {
          return (snapshot["encounters"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounters")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelEncounterConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelEncounterConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class DeleteProviderMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteProvider($input: DeleteProviderInput!, $condition: ModelProviderConditionInput) {\n  deleteProvider(input: $input, condition: $condition) {\n    __typename\n    id\n    firstName\n    lastName\n    phoneNumber\n    encounters {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteProviderInput
  public var condition: ModelProviderConditionInput?

  public init(input: DeleteProviderInput, condition: ModelProviderConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteProvider", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteProvider.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteProvider: DeleteProvider? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteProvider": deleteProvider.flatMap { $0.snapshot }])
    }

    public var deleteProvider: DeleteProvider? {
      get {
        return (snapshot["deleteProvider"] as? Snapshot).flatMap { DeleteProvider(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteProvider")
      }
    }

    public struct DeleteProvider: GraphQLSelectionSet {
      public static let possibleTypes = ["Provider"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("phoneNumber", type: .scalar(String.self)),
        GraphQLField("encounters", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, encounters: Encounter? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "encounters": encounters.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var phoneNumber: String? {
        get {
          return snapshot["phoneNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var encounters: Encounter? {
        get {
          return (snapshot["encounters"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounters")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelEncounterConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelEncounterConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class CreateEncounterMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateEncounter($input: CreateEncounterInput!, $condition: ModelEncounterConditionInput) {\n  createEncounter(input: $input, condition: $condition) {\n    __typename\n    id\n    scans {\n      __typename\n      nextToken\n    }\n    vaccines {\n      __typename\n      nextToken\n    }\n    provider {\n      __typename\n      id\n      firstName\n      lastName\n      phoneNumber\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    providerEncountersId\n  }\n}"

  public var input: CreateEncounterInput
  public var condition: ModelEncounterConditionInput?

  public init(input: CreateEncounterInput, condition: ModelEncounterConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createEncounter", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateEncounter.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createEncounter: CreateEncounter? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createEncounter": createEncounter.flatMap { $0.snapshot }])
    }

    public var createEncounter: CreateEncounter? {
      get {
        return (snapshot["createEncounter"] as? Snapshot).flatMap { CreateEncounter(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createEncounter")
      }
    }

    public struct CreateEncounter: GraphQLSelectionSet {
      public static let possibleTypes = ["Encounter"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("scans", type: .object(Scan.selections)),
        GraphQLField("vaccines", type: .object(Vaccine.selections)),
        GraphQLField("provider", type: .object(Provider.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, scans: Scan? = nil, vaccines: Vaccine? = nil, provider: Provider? = nil, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Encounter", "id": id, "scans": scans.flatMap { $0.snapshot }, "vaccines": vaccines.flatMap { $0.snapshot }, "provider": provider.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var scans: Scan? {
        get {
          return (snapshot["scans"] as? Snapshot).flatMap { Scan(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "scans")
        }
      }

      public var vaccines: Vaccine? {
        get {
          return (snapshot["vaccines"] as? Snapshot).flatMap { Vaccine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccines")
        }
      }

      public var provider: Provider? {
        get {
          return (snapshot["provider"] as? Snapshot).flatMap { Provider(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "provider")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var providerEncountersId: GraphQLID? {
        get {
          return snapshot["providerEncountersId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "providerEncountersId")
        }
      }

      public struct Scan: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelScanConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelScanConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Vaccine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVaccineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVaccineConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Provider: GraphQLSelectionSet {
        public static let possibleTypes = ["Provider"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("phoneNumber", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public var phoneNumber: String? {
          get {
            return snapshot["phoneNumber"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class UpdateEncounterMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateEncounter($input: UpdateEncounterInput!, $condition: ModelEncounterConditionInput) {\n  updateEncounter(input: $input, condition: $condition) {\n    __typename\n    id\n    scans {\n      __typename\n      nextToken\n    }\n    vaccines {\n      __typename\n      nextToken\n    }\n    provider {\n      __typename\n      id\n      firstName\n      lastName\n      phoneNumber\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    providerEncountersId\n  }\n}"

  public var input: UpdateEncounterInput
  public var condition: ModelEncounterConditionInput?

  public init(input: UpdateEncounterInput, condition: ModelEncounterConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateEncounter", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateEncounter.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateEncounter: UpdateEncounter? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateEncounter": updateEncounter.flatMap { $0.snapshot }])
    }

    public var updateEncounter: UpdateEncounter? {
      get {
        return (snapshot["updateEncounter"] as? Snapshot).flatMap { UpdateEncounter(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateEncounter")
      }
    }

    public struct UpdateEncounter: GraphQLSelectionSet {
      public static let possibleTypes = ["Encounter"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("scans", type: .object(Scan.selections)),
        GraphQLField("vaccines", type: .object(Vaccine.selections)),
        GraphQLField("provider", type: .object(Provider.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, scans: Scan? = nil, vaccines: Vaccine? = nil, provider: Provider? = nil, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Encounter", "id": id, "scans": scans.flatMap { $0.snapshot }, "vaccines": vaccines.flatMap { $0.snapshot }, "provider": provider.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var scans: Scan? {
        get {
          return (snapshot["scans"] as? Snapshot).flatMap { Scan(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "scans")
        }
      }

      public var vaccines: Vaccine? {
        get {
          return (snapshot["vaccines"] as? Snapshot).flatMap { Vaccine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccines")
        }
      }

      public var provider: Provider? {
        get {
          return (snapshot["provider"] as? Snapshot).flatMap { Provider(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "provider")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var providerEncountersId: GraphQLID? {
        get {
          return snapshot["providerEncountersId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "providerEncountersId")
        }
      }

      public struct Scan: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelScanConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelScanConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Vaccine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVaccineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVaccineConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Provider: GraphQLSelectionSet {
        public static let possibleTypes = ["Provider"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("phoneNumber", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public var phoneNumber: String? {
          get {
            return snapshot["phoneNumber"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class DeleteEncounterMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteEncounter($input: DeleteEncounterInput!, $condition: ModelEncounterConditionInput) {\n  deleteEncounter(input: $input, condition: $condition) {\n    __typename\n    id\n    scans {\n      __typename\n      nextToken\n    }\n    vaccines {\n      __typename\n      nextToken\n    }\n    provider {\n      __typename\n      id\n      firstName\n      lastName\n      phoneNumber\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    providerEncountersId\n  }\n}"

  public var input: DeleteEncounterInput
  public var condition: ModelEncounterConditionInput?

  public init(input: DeleteEncounterInput, condition: ModelEncounterConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteEncounter", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteEncounter.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteEncounter: DeleteEncounter? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteEncounter": deleteEncounter.flatMap { $0.snapshot }])
    }

    public var deleteEncounter: DeleteEncounter? {
      get {
        return (snapshot["deleteEncounter"] as? Snapshot).flatMap { DeleteEncounter(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteEncounter")
      }
    }

    public struct DeleteEncounter: GraphQLSelectionSet {
      public static let possibleTypes = ["Encounter"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("scans", type: .object(Scan.selections)),
        GraphQLField("vaccines", type: .object(Vaccine.selections)),
        GraphQLField("provider", type: .object(Provider.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, scans: Scan? = nil, vaccines: Vaccine? = nil, provider: Provider? = nil, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Encounter", "id": id, "scans": scans.flatMap { $0.snapshot }, "vaccines": vaccines.flatMap { $0.snapshot }, "provider": provider.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var scans: Scan? {
        get {
          return (snapshot["scans"] as? Snapshot).flatMap { Scan(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "scans")
        }
      }

      public var vaccines: Vaccine? {
        get {
          return (snapshot["vaccines"] as? Snapshot).flatMap { Vaccine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccines")
        }
      }

      public var provider: Provider? {
        get {
          return (snapshot["provider"] as? Snapshot).flatMap { Provider(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "provider")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var providerEncountersId: GraphQLID? {
        get {
          return snapshot["providerEncountersId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "providerEncountersId")
        }
      }

      public struct Scan: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelScanConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelScanConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Vaccine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVaccineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVaccineConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Provider: GraphQLSelectionSet {
        public static let possibleTypes = ["Provider"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("phoneNumber", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public var phoneNumber: String? {
          get {
            return snapshot["phoneNumber"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class CreateVaccineMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateVaccine($input: CreateVaccineInput!, $condition: ModelVaccineConditionInput) {\n  createVaccine(input: $input, condition: $condition) {\n    __typename\n    id\n    lotNumber\n    expirationDate\n    vaccineType {\n      __typename\n      id\n      name\n      createdAt\n      updatedAt\n    }\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterVaccinesId\n  }\n}"

  public var input: CreateVaccineInput
  public var condition: ModelVaccineConditionInput?

  public init(input: CreateVaccineInput, condition: ModelVaccineConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createVaccine", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateVaccine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createVaccine: CreateVaccine? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createVaccine": createVaccine.flatMap { $0.snapshot }])
    }

    public var createVaccine: CreateVaccine? {
      get {
        return (snapshot["createVaccine"] as? Snapshot).flatMap { CreateVaccine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createVaccine")
      }
    }

    public struct CreateVaccine: GraphQLSelectionSet {
      public static let possibleTypes = ["Vaccine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("lotNumber", type: .scalar(String.self)),
        GraphQLField("expirationDate", type: .scalar(String.self)),
        GraphQLField("vaccineType", type: .object(VaccineType.selections)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterVaccinesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, lotNumber: String? = nil, expirationDate: String? = nil, vaccineType: VaccineType? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterVaccinesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Vaccine", "id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "vaccineType": vaccineType.flatMap { $0.snapshot }, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterVaccinesId": encounterVaccinesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var lotNumber: String? {
        get {
          return snapshot["lotNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lotNumber")
        }
      }

      public var expirationDate: String? {
        get {
          return snapshot["expirationDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "expirationDate")
        }
      }

      public var vaccineType: VaccineType? {
        get {
          return (snapshot["vaccineType"] as? Snapshot).flatMap { VaccineType(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccineType")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterVaccinesId: GraphQLID? {
        get {
          return snapshot["encounterVaccinesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterVaccinesId")
        }
      }

      public struct VaccineType: GraphQLSelectionSet {
        public static let possibleTypes = ["VaccineType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return snapshot["name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class UpdateVaccineMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateVaccine($input: UpdateVaccineInput!, $condition: ModelVaccineConditionInput) {\n  updateVaccine(input: $input, condition: $condition) {\n    __typename\n    id\n    lotNumber\n    expirationDate\n    vaccineType {\n      __typename\n      id\n      name\n      createdAt\n      updatedAt\n    }\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterVaccinesId\n  }\n}"

  public var input: UpdateVaccineInput
  public var condition: ModelVaccineConditionInput?

  public init(input: UpdateVaccineInput, condition: ModelVaccineConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateVaccine", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateVaccine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateVaccine: UpdateVaccine? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateVaccine": updateVaccine.flatMap { $0.snapshot }])
    }

    public var updateVaccine: UpdateVaccine? {
      get {
        return (snapshot["updateVaccine"] as? Snapshot).flatMap { UpdateVaccine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateVaccine")
      }
    }

    public struct UpdateVaccine: GraphQLSelectionSet {
      public static let possibleTypes = ["Vaccine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("lotNumber", type: .scalar(String.self)),
        GraphQLField("expirationDate", type: .scalar(String.self)),
        GraphQLField("vaccineType", type: .object(VaccineType.selections)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterVaccinesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, lotNumber: String? = nil, expirationDate: String? = nil, vaccineType: VaccineType? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterVaccinesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Vaccine", "id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "vaccineType": vaccineType.flatMap { $0.snapshot }, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterVaccinesId": encounterVaccinesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var lotNumber: String? {
        get {
          return snapshot["lotNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lotNumber")
        }
      }

      public var expirationDate: String? {
        get {
          return snapshot["expirationDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "expirationDate")
        }
      }

      public var vaccineType: VaccineType? {
        get {
          return (snapshot["vaccineType"] as? Snapshot).flatMap { VaccineType(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccineType")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterVaccinesId: GraphQLID? {
        get {
          return snapshot["encounterVaccinesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterVaccinesId")
        }
      }

      public struct VaccineType: GraphQLSelectionSet {
        public static let possibleTypes = ["VaccineType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return snapshot["name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class DeleteVaccineMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteVaccine($input: DeleteVaccineInput!, $condition: ModelVaccineConditionInput) {\n  deleteVaccine(input: $input, condition: $condition) {\n    __typename\n    id\n    lotNumber\n    expirationDate\n    vaccineType {\n      __typename\n      id\n      name\n      createdAt\n      updatedAt\n    }\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterVaccinesId\n  }\n}"

  public var input: DeleteVaccineInput
  public var condition: ModelVaccineConditionInput?

  public init(input: DeleteVaccineInput, condition: ModelVaccineConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteVaccine", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteVaccine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteVaccine: DeleteVaccine? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteVaccine": deleteVaccine.flatMap { $0.snapshot }])
    }

    public var deleteVaccine: DeleteVaccine? {
      get {
        return (snapshot["deleteVaccine"] as? Snapshot).flatMap { DeleteVaccine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteVaccine")
      }
    }

    public struct DeleteVaccine: GraphQLSelectionSet {
      public static let possibleTypes = ["Vaccine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("lotNumber", type: .scalar(String.self)),
        GraphQLField("expirationDate", type: .scalar(String.self)),
        GraphQLField("vaccineType", type: .object(VaccineType.selections)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterVaccinesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, lotNumber: String? = nil, expirationDate: String? = nil, vaccineType: VaccineType? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterVaccinesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Vaccine", "id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "vaccineType": vaccineType.flatMap { $0.snapshot }, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterVaccinesId": encounterVaccinesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var lotNumber: String? {
        get {
          return snapshot["lotNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lotNumber")
        }
      }

      public var expirationDate: String? {
        get {
          return snapshot["expirationDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "expirationDate")
        }
      }

      public var vaccineType: VaccineType? {
        get {
          return (snapshot["vaccineType"] as? Snapshot).flatMap { VaccineType(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccineType")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterVaccinesId: GraphQLID? {
        get {
          return snapshot["encounterVaccinesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterVaccinesId")
        }
      }

      public struct VaccineType: GraphQLSelectionSet {
        public static let possibleTypes = ["VaccineType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return snapshot["name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class CreateVaccineTypeMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateVaccineType($input: CreateVaccineTypeInput!, $condition: ModelVaccineTypeConditionInput) {\n  createVaccineType(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateVaccineTypeInput
  public var condition: ModelVaccineTypeConditionInput?

  public init(input: CreateVaccineTypeInput, condition: ModelVaccineTypeConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createVaccineType", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateVaccineType.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createVaccineType: CreateVaccineType? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createVaccineType": createVaccineType.flatMap { $0.snapshot }])
    }

    public var createVaccineType: CreateVaccineType? {
      get {
        return (snapshot["createVaccineType"] as? Snapshot).flatMap { CreateVaccineType(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createVaccineType")
      }
    }

    public struct CreateVaccineType: GraphQLSelectionSet {
      public static let possibleTypes = ["VaccineType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class UpdateVaccineTypeMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateVaccineType($input: UpdateVaccineTypeInput!, $condition: ModelVaccineTypeConditionInput) {\n  updateVaccineType(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateVaccineTypeInput
  public var condition: ModelVaccineTypeConditionInput?

  public init(input: UpdateVaccineTypeInput, condition: ModelVaccineTypeConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateVaccineType", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateVaccineType.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateVaccineType: UpdateVaccineType? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateVaccineType": updateVaccineType.flatMap { $0.snapshot }])
    }

    public var updateVaccineType: UpdateVaccineType? {
      get {
        return (snapshot["updateVaccineType"] as? Snapshot).flatMap { UpdateVaccineType(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateVaccineType")
      }
    }

    public struct UpdateVaccineType: GraphQLSelectionSet {
      public static let possibleTypes = ["VaccineType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class DeleteVaccineTypeMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteVaccineType($input: DeleteVaccineTypeInput!, $condition: ModelVaccineTypeConditionInput) {\n  deleteVaccineType(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteVaccineTypeInput
  public var condition: ModelVaccineTypeConditionInput?

  public init(input: DeleteVaccineTypeInput, condition: ModelVaccineTypeConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteVaccineType", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteVaccineType.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteVaccineType: DeleteVaccineType? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteVaccineType": deleteVaccineType.flatMap { $0.snapshot }])
    }

    public var deleteVaccineType: DeleteVaccineType? {
      get {
        return (snapshot["deleteVaccineType"] as? Snapshot).flatMap { DeleteVaccineType(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteVaccineType")
      }
    }

    public struct DeleteVaccineType: GraphQLSelectionSet {
      public static let possibleTypes = ["VaccineType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class CreateScanMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateScan($input: CreateScanInput!, $condition: ModelScanConditionInput) {\n  createScan(input: $input, condition: $condition) {\n    __typename\n    id\n    fileName\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterScansId\n  }\n}"

  public var input: CreateScanInput
  public var condition: ModelScanConditionInput?

  public init(input: CreateScanInput, condition: ModelScanConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createScan", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateScan.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createScan: CreateScan? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createScan": createScan.flatMap { $0.snapshot }])
    }

    public var createScan: CreateScan? {
      get {
        return (snapshot["createScan"] as? Snapshot).flatMap { CreateScan(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createScan")
      }
    }

    public struct CreateScan: GraphQLSelectionSet {
      public static let possibleTypes = ["Scan"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("fileName", type: .scalar(String.self)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterScansId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, fileName: String? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterScansId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Scan", "id": id, "fileName": fileName, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterScansId": encounterScansId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var fileName: String? {
        get {
          return snapshot["fileName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fileName")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterScansId: GraphQLID? {
        get {
          return snapshot["encounterScansId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterScansId")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class UpdateScanMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateScan($input: UpdateScanInput!, $condition: ModelScanConditionInput) {\n  updateScan(input: $input, condition: $condition) {\n    __typename\n    id\n    fileName\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterScansId\n  }\n}"

  public var input: UpdateScanInput
  public var condition: ModelScanConditionInput?

  public init(input: UpdateScanInput, condition: ModelScanConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateScan", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateScan.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateScan: UpdateScan? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateScan": updateScan.flatMap { $0.snapshot }])
    }

    public var updateScan: UpdateScan? {
      get {
        return (snapshot["updateScan"] as? Snapshot).flatMap { UpdateScan(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateScan")
      }
    }

    public struct UpdateScan: GraphQLSelectionSet {
      public static let possibleTypes = ["Scan"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("fileName", type: .scalar(String.self)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterScansId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, fileName: String? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterScansId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Scan", "id": id, "fileName": fileName, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterScansId": encounterScansId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var fileName: String? {
        get {
          return snapshot["fileName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fileName")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterScansId: GraphQLID? {
        get {
          return snapshot["encounterScansId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterScansId")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class DeleteScanMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteScan($input: DeleteScanInput!, $condition: ModelScanConditionInput) {\n  deleteScan(input: $input, condition: $condition) {\n    __typename\n    id\n    fileName\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterScansId\n  }\n}"

  public var input: DeleteScanInput
  public var condition: ModelScanConditionInput?

  public init(input: DeleteScanInput, condition: ModelScanConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteScan", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteScan.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteScan: DeleteScan? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteScan": deleteScan.flatMap { $0.snapshot }])
    }

    public var deleteScan: DeleteScan? {
      get {
        return (snapshot["deleteScan"] as? Snapshot).flatMap { DeleteScan(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteScan")
      }
    }

    public struct DeleteScan: GraphQLSelectionSet {
      public static let possibleTypes = ["Scan"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("fileName", type: .scalar(String.self)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterScansId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, fileName: String? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterScansId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Scan", "id": id, "fileName": fileName, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterScansId": encounterScansId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var fileName: String? {
        get {
          return snapshot["fileName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fileName")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterScansId: GraphQLID? {
        get {
          return snapshot["encounterScansId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterScansId")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class GetPatientQuery: GraphQLQuery {
  public static let operationString =
    "query GetPatient($id: ID!) {\n  getPatient(id: $id) {\n    __typename\n    id\n    firstName\n    lastName\n    dateOfBirth\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getPatient", arguments: ["id": GraphQLVariable("id")], type: .object(GetPatient.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getPatient: GetPatient? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPatient": getPatient.flatMap { $0.snapshot }])
    }

    public var getPatient: GetPatient? {
      get {
        return (snapshot["getPatient"] as? Snapshot).flatMap { GetPatient(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getPatient")
      }
    }

    public struct GetPatient: GraphQLSelectionSet {
      public static let possibleTypes = ["Patient"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("dateOfBirth", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, dateOfBirth: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Patient", "id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var dateOfBirth: String? {
        get {
          return snapshot["dateOfBirth"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateOfBirth")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class ListPatientsQuery: GraphQLQuery {
  public static let operationString =
    "query ListPatients($id: ID, $filter: ModelPatientFilterInput, $limit: Int, $nextToken: String, $sortDirection: ModelSortDirection) {\n  listPatients(\n    id: $id\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    sortDirection: $sortDirection\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      firstName\n      lastName\n      dateOfBirth\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var id: GraphQLID?
  public var filter: ModelPatientFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var sortDirection: ModelSortDirection?

  public init(id: GraphQLID? = nil, filter: ModelPatientFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, sortDirection: ModelSortDirection? = nil) {
    self.id = id
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.sortDirection = sortDirection
  }

  public var variables: GraphQLMap? {
    return ["id": id, "filter": filter, "limit": limit, "nextToken": nextToken, "sortDirection": sortDirection]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listPatients", arguments: ["id": GraphQLVariable("id"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "sortDirection": GraphQLVariable("sortDirection")], type: .object(ListPatient.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listPatients: ListPatient? = nil) {
      self.init(snapshot: ["__typename": "Query", "listPatients": listPatients.flatMap { $0.snapshot }])
    }

    public var listPatients: ListPatient? {
      get {
        return (snapshot["listPatients"] as? Snapshot).flatMap { ListPatient(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listPatients")
      }
    }

    public struct ListPatient: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelPatientConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelPatientConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Patient"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("dateOfBirth", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, dateOfBirth: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Patient", "id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public var dateOfBirth: String? {
          get {
            return snapshot["dateOfBirth"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "dateOfBirth")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetProviderQuery: GraphQLQuery {
  public static let operationString =
    "query GetProvider($id: ID!) {\n  getProvider(id: $id) {\n    __typename\n    id\n    firstName\n    lastName\n    phoneNumber\n    encounters {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getProvider", arguments: ["id": GraphQLVariable("id")], type: .object(GetProvider.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getProvider: GetProvider? = nil) {
      self.init(snapshot: ["__typename": "Query", "getProvider": getProvider.flatMap { $0.snapshot }])
    }

    public var getProvider: GetProvider? {
      get {
        return (snapshot["getProvider"] as? Snapshot).flatMap { GetProvider(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getProvider")
      }
    }

    public struct GetProvider: GraphQLSelectionSet {
      public static let possibleTypes = ["Provider"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("phoneNumber", type: .scalar(String.self)),
        GraphQLField("encounters", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, encounters: Encounter? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "encounters": encounters.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var phoneNumber: String? {
        get {
          return snapshot["phoneNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var encounters: Encounter? {
        get {
          return (snapshot["encounters"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounters")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelEncounterConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelEncounterConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class ListProvidersQuery: GraphQLQuery {
  public static let operationString =
    "query ListProviders($id: ID, $filter: ModelProviderFilterInput, $limit: Int, $nextToken: String, $sortDirection: ModelSortDirection) {\n  listProviders(\n    id: $id\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    sortDirection: $sortDirection\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      firstName\n      lastName\n      phoneNumber\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var id: GraphQLID?
  public var filter: ModelProviderFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var sortDirection: ModelSortDirection?

  public init(id: GraphQLID? = nil, filter: ModelProviderFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, sortDirection: ModelSortDirection? = nil) {
    self.id = id
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.sortDirection = sortDirection
  }

  public var variables: GraphQLMap? {
    return ["id": id, "filter": filter, "limit": limit, "nextToken": nextToken, "sortDirection": sortDirection]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listProviders", arguments: ["id": GraphQLVariable("id"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "sortDirection": GraphQLVariable("sortDirection")], type: .object(ListProvider.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listProviders: ListProvider? = nil) {
      self.init(snapshot: ["__typename": "Query", "listProviders": listProviders.flatMap { $0.snapshot }])
    }

    public var listProviders: ListProvider? {
      get {
        return (snapshot["listProviders"] as? Snapshot).flatMap { ListProvider(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listProviders")
      }
    }

    public struct ListProvider: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelProviderConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelProviderConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Provider"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("phoneNumber", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public var phoneNumber: String? {
          get {
            return snapshot["phoneNumber"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetEncounterQuery: GraphQLQuery {
  public static let operationString =
    "query GetEncounter($id: ID!) {\n  getEncounter(id: $id) {\n    __typename\n    id\n    scans {\n      __typename\n      nextToken\n    }\n    vaccines {\n      __typename\n      nextToken\n    }\n    provider {\n      __typename\n      id\n      firstName\n      lastName\n      phoneNumber\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    providerEncountersId\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getEncounter", arguments: ["id": GraphQLVariable("id")], type: .object(GetEncounter.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getEncounter: GetEncounter? = nil) {
      self.init(snapshot: ["__typename": "Query", "getEncounter": getEncounter.flatMap { $0.snapshot }])
    }

    public var getEncounter: GetEncounter? {
      get {
        return (snapshot["getEncounter"] as? Snapshot).flatMap { GetEncounter(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getEncounter")
      }
    }

    public struct GetEncounter: GraphQLSelectionSet {
      public static let possibleTypes = ["Encounter"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("scans", type: .object(Scan.selections)),
        GraphQLField("vaccines", type: .object(Vaccine.selections)),
        GraphQLField("provider", type: .object(Provider.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, scans: Scan? = nil, vaccines: Vaccine? = nil, provider: Provider? = nil, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Encounter", "id": id, "scans": scans.flatMap { $0.snapshot }, "vaccines": vaccines.flatMap { $0.snapshot }, "provider": provider.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var scans: Scan? {
        get {
          return (snapshot["scans"] as? Snapshot).flatMap { Scan(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "scans")
        }
      }

      public var vaccines: Vaccine? {
        get {
          return (snapshot["vaccines"] as? Snapshot).flatMap { Vaccine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccines")
        }
      }

      public var provider: Provider? {
        get {
          return (snapshot["provider"] as? Snapshot).flatMap { Provider(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "provider")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var providerEncountersId: GraphQLID? {
        get {
          return snapshot["providerEncountersId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "providerEncountersId")
        }
      }

      public struct Scan: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelScanConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelScanConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Vaccine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVaccineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVaccineConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Provider: GraphQLSelectionSet {
        public static let possibleTypes = ["Provider"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("phoneNumber", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public var phoneNumber: String? {
          get {
            return snapshot["phoneNumber"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class ListEncountersQuery: GraphQLQuery {
  public static let operationString =
    "query ListEncounters($id: ID, $filter: ModelEncounterFilterInput, $limit: Int, $nextToken: String, $sortDirection: ModelSortDirection) {\n  listEncounters(\n    id: $id\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    sortDirection: $sortDirection\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    nextToken\n  }\n}"

  public var id: GraphQLID?
  public var filter: ModelEncounterFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var sortDirection: ModelSortDirection?

  public init(id: GraphQLID? = nil, filter: ModelEncounterFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, sortDirection: ModelSortDirection? = nil) {
    self.id = id
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.sortDirection = sortDirection
  }

  public var variables: GraphQLMap? {
    return ["id": id, "filter": filter, "limit": limit, "nextToken": nextToken, "sortDirection": sortDirection]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listEncounters", arguments: ["id": GraphQLVariable("id"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "sortDirection": GraphQLVariable("sortDirection")], type: .object(ListEncounter.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listEncounters: ListEncounter? = nil) {
      self.init(snapshot: ["__typename": "Query", "listEncounters": listEncounters.flatMap { $0.snapshot }])
    }

    public var listEncounters: ListEncounter? {
      get {
        return (snapshot["listEncounters"] as? Snapshot).flatMap { ListEncounter(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listEncounters")
      }
    }

    public struct ListEncounter: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelEncounterConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelEncounterConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class GetVaccineQuery: GraphQLQuery {
  public static let operationString =
    "query GetVaccine($id: ID!) {\n  getVaccine(id: $id) {\n    __typename\n    id\n    lotNumber\n    expirationDate\n    vaccineType {\n      __typename\n      id\n      name\n      createdAt\n      updatedAt\n    }\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterVaccinesId\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getVaccine", arguments: ["id": GraphQLVariable("id")], type: .object(GetVaccine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getVaccine: GetVaccine? = nil) {
      self.init(snapshot: ["__typename": "Query", "getVaccine": getVaccine.flatMap { $0.snapshot }])
    }

    public var getVaccine: GetVaccine? {
      get {
        return (snapshot["getVaccine"] as? Snapshot).flatMap { GetVaccine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getVaccine")
      }
    }

    public struct GetVaccine: GraphQLSelectionSet {
      public static let possibleTypes = ["Vaccine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("lotNumber", type: .scalar(String.self)),
        GraphQLField("expirationDate", type: .scalar(String.self)),
        GraphQLField("vaccineType", type: .object(VaccineType.selections)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterVaccinesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, lotNumber: String? = nil, expirationDate: String? = nil, vaccineType: VaccineType? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterVaccinesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Vaccine", "id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "vaccineType": vaccineType.flatMap { $0.snapshot }, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterVaccinesId": encounterVaccinesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var lotNumber: String? {
        get {
          return snapshot["lotNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lotNumber")
        }
      }

      public var expirationDate: String? {
        get {
          return snapshot["expirationDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "expirationDate")
        }
      }

      public var vaccineType: VaccineType? {
        get {
          return (snapshot["vaccineType"] as? Snapshot).flatMap { VaccineType(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccineType")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterVaccinesId: GraphQLID? {
        get {
          return snapshot["encounterVaccinesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterVaccinesId")
        }
      }

      public struct VaccineType: GraphQLSelectionSet {
        public static let possibleTypes = ["VaccineType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return snapshot["name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class ListVaccinesQuery: GraphQLQuery {
  public static let operationString =
    "query ListVaccines($id: ID, $filter: ModelVaccineFilterInput, $limit: Int, $nextToken: String, $sortDirection: ModelSortDirection) {\n  listVaccines(\n    id: $id\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    sortDirection: $sortDirection\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      lotNumber\n      expirationDate\n      createdAt\n      updatedAt\n      encounterVaccinesId\n    }\n    nextToken\n  }\n}"

  public var id: GraphQLID?
  public var filter: ModelVaccineFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var sortDirection: ModelSortDirection?

  public init(id: GraphQLID? = nil, filter: ModelVaccineFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, sortDirection: ModelSortDirection? = nil) {
    self.id = id
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.sortDirection = sortDirection
  }

  public var variables: GraphQLMap? {
    return ["id": id, "filter": filter, "limit": limit, "nextToken": nextToken, "sortDirection": sortDirection]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listVaccines", arguments: ["id": GraphQLVariable("id"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "sortDirection": GraphQLVariable("sortDirection")], type: .object(ListVaccine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listVaccines: ListVaccine? = nil) {
      self.init(snapshot: ["__typename": "Query", "listVaccines": listVaccines.flatMap { $0.snapshot }])
    }

    public var listVaccines: ListVaccine? {
      get {
        return (snapshot["listVaccines"] as? Snapshot).flatMap { ListVaccine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listVaccines")
      }
    }

    public struct ListVaccine: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelVaccineConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelVaccineConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Vaccine"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("lotNumber", type: .scalar(String.self)),
          GraphQLField("expirationDate", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("encounterVaccinesId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, lotNumber: String? = nil, expirationDate: String? = nil, createdAt: String, updatedAt: String, encounterVaccinesId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Vaccine", "id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "createdAt": createdAt, "updatedAt": updatedAt, "encounterVaccinesId": encounterVaccinesId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var lotNumber: String? {
          get {
            return snapshot["lotNumber"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lotNumber")
          }
        }

        public var expirationDate: String? {
          get {
            return snapshot["expirationDate"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "expirationDate")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var encounterVaccinesId: GraphQLID? {
          get {
            return snapshot["encounterVaccinesId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "encounterVaccinesId")
          }
        }
      }
    }
  }
}

public final class GetVaccineTypeQuery: GraphQLQuery {
  public static let operationString =
    "query GetVaccineType($id: ID!) {\n  getVaccineType(id: $id) {\n    __typename\n    id\n    name\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getVaccineType", arguments: ["id": GraphQLVariable("id")], type: .object(GetVaccineType.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getVaccineType: GetVaccineType? = nil) {
      self.init(snapshot: ["__typename": "Query", "getVaccineType": getVaccineType.flatMap { $0.snapshot }])
    }

    public var getVaccineType: GetVaccineType? {
      get {
        return (snapshot["getVaccineType"] as? Snapshot).flatMap { GetVaccineType(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getVaccineType")
      }
    }

    public struct GetVaccineType: GraphQLSelectionSet {
      public static let possibleTypes = ["VaccineType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class ListVaccineTypesQuery: GraphQLQuery {
  public static let operationString =
    "query ListVaccineTypes($id: ID, $filter: ModelVaccineTypeFilterInput, $limit: Int, $nextToken: String, $sortDirection: ModelSortDirection) {\n  listVaccineTypes(\n    id: $id\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    sortDirection: $sortDirection\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      name\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var id: GraphQLID?
  public var filter: ModelVaccineTypeFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var sortDirection: ModelSortDirection?

  public init(id: GraphQLID? = nil, filter: ModelVaccineTypeFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, sortDirection: ModelSortDirection? = nil) {
    self.id = id
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.sortDirection = sortDirection
  }

  public var variables: GraphQLMap? {
    return ["id": id, "filter": filter, "limit": limit, "nextToken": nextToken, "sortDirection": sortDirection]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listVaccineTypes", arguments: ["id": GraphQLVariable("id"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "sortDirection": GraphQLVariable("sortDirection")], type: .object(ListVaccineType.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listVaccineTypes: ListVaccineType? = nil) {
      self.init(snapshot: ["__typename": "Query", "listVaccineTypes": listVaccineTypes.flatMap { $0.snapshot }])
    }

    public var listVaccineTypes: ListVaccineType? {
      get {
        return (snapshot["listVaccineTypes"] as? Snapshot).flatMap { ListVaccineType(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listVaccineTypes")
      }
    }

    public struct ListVaccineType: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelVaccineTypeConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelVaccineTypeConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["VaccineType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return snapshot["name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetScanQuery: GraphQLQuery {
  public static let operationString =
    "query GetScan($id: ID!) {\n  getScan(id: $id) {\n    __typename\n    id\n    fileName\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterScansId\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getScan", arguments: ["id": GraphQLVariable("id")], type: .object(GetScan.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getScan: GetScan? = nil) {
      self.init(snapshot: ["__typename": "Query", "getScan": getScan.flatMap { $0.snapshot }])
    }

    public var getScan: GetScan? {
      get {
        return (snapshot["getScan"] as? Snapshot).flatMap { GetScan(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getScan")
      }
    }

    public struct GetScan: GraphQLSelectionSet {
      public static let possibleTypes = ["Scan"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("fileName", type: .scalar(String.self)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterScansId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, fileName: String? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterScansId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Scan", "id": id, "fileName": fileName, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterScansId": encounterScansId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var fileName: String? {
        get {
          return snapshot["fileName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fileName")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterScansId: GraphQLID? {
        get {
          return snapshot["encounterScansId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterScansId")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class ListScansQuery: GraphQLQuery {
  public static let operationString =
    "query ListScans($id: ID, $filter: ModelScanFilterInput, $limit: Int, $nextToken: String, $sortDirection: ModelSortDirection) {\n  listScans(\n    id: $id\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    sortDirection: $sortDirection\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      fileName\n      createdAt\n      updatedAt\n      encounterScansId\n    }\n    nextToken\n  }\n}"

  public var id: GraphQLID?
  public var filter: ModelScanFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var sortDirection: ModelSortDirection?

  public init(id: GraphQLID? = nil, filter: ModelScanFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, sortDirection: ModelSortDirection? = nil) {
    self.id = id
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.sortDirection = sortDirection
  }

  public var variables: GraphQLMap? {
    return ["id": id, "filter": filter, "limit": limit, "nextToken": nextToken, "sortDirection": sortDirection]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listScans", arguments: ["id": GraphQLVariable("id"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "sortDirection": GraphQLVariable("sortDirection")], type: .object(ListScan.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listScans: ListScan? = nil) {
      self.init(snapshot: ["__typename": "Query", "listScans": listScans.flatMap { $0.snapshot }])
    }

    public var listScans: ListScan? {
      get {
        return (snapshot["listScans"] as? Snapshot).flatMap { ListScan(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listScans")
      }
    }

    public struct ListScan: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelScanConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelScanConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Scan"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("fileName", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("encounterScansId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, fileName: String? = nil, createdAt: String, updatedAt: String, encounterScansId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Scan", "id": id, "fileName": fileName, "createdAt": createdAt, "updatedAt": updatedAt, "encounterScansId": encounterScansId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var fileName: String? {
          get {
            return snapshot["fileName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "fileName")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var encounterScansId: GraphQLID? {
          get {
            return snapshot["encounterScansId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "encounterScansId")
          }
        }
      }
    }
  }
}

public final class OnCreatePatientSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreatePatient($filter: ModelSubscriptionPatientFilterInput) {\n  onCreatePatient(filter: $filter) {\n    __typename\n    id\n    firstName\n    lastName\n    dateOfBirth\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionPatientFilterInput?

  public init(filter: ModelSubscriptionPatientFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreatePatient", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreatePatient.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreatePatient: OnCreatePatient? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreatePatient": onCreatePatient.flatMap { $0.snapshot }])
    }

    public var onCreatePatient: OnCreatePatient? {
      get {
        return (snapshot["onCreatePatient"] as? Snapshot).flatMap { OnCreatePatient(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreatePatient")
      }
    }

    public struct OnCreatePatient: GraphQLSelectionSet {
      public static let possibleTypes = ["Patient"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("dateOfBirth", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, dateOfBirth: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Patient", "id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var dateOfBirth: String? {
        get {
          return snapshot["dateOfBirth"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateOfBirth")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnUpdatePatientSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdatePatient($filter: ModelSubscriptionPatientFilterInput) {\n  onUpdatePatient(filter: $filter) {\n    __typename\n    id\n    firstName\n    lastName\n    dateOfBirth\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionPatientFilterInput?

  public init(filter: ModelSubscriptionPatientFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdatePatient", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdatePatient.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdatePatient: OnUpdatePatient? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdatePatient": onUpdatePatient.flatMap { $0.snapshot }])
    }

    public var onUpdatePatient: OnUpdatePatient? {
      get {
        return (snapshot["onUpdatePatient"] as? Snapshot).flatMap { OnUpdatePatient(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdatePatient")
      }
    }

    public struct OnUpdatePatient: GraphQLSelectionSet {
      public static let possibleTypes = ["Patient"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("dateOfBirth", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, dateOfBirth: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Patient", "id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var dateOfBirth: String? {
        get {
          return snapshot["dateOfBirth"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateOfBirth")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnDeletePatientSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeletePatient($filter: ModelSubscriptionPatientFilterInput) {\n  onDeletePatient(filter: $filter) {\n    __typename\n    id\n    firstName\n    lastName\n    dateOfBirth\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionPatientFilterInput?

  public init(filter: ModelSubscriptionPatientFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeletePatient", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeletePatient.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeletePatient: OnDeletePatient? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeletePatient": onDeletePatient.flatMap { $0.snapshot }])
    }

    public var onDeletePatient: OnDeletePatient? {
      get {
        return (snapshot["onDeletePatient"] as? Snapshot).flatMap { OnDeletePatient(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeletePatient")
      }
    }

    public struct OnDeletePatient: GraphQLSelectionSet {
      public static let possibleTypes = ["Patient"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("dateOfBirth", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, dateOfBirth: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Patient", "id": id, "firstName": firstName, "lastName": lastName, "dateOfBirth": dateOfBirth, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var dateOfBirth: String? {
        get {
          return snapshot["dateOfBirth"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateOfBirth")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnCreateProviderSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateProvider($filter: ModelSubscriptionProviderFilterInput) {\n  onCreateProvider(filter: $filter) {\n    __typename\n    id\n    firstName\n    lastName\n    phoneNumber\n    encounters {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionProviderFilterInput?

  public init(filter: ModelSubscriptionProviderFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateProvider", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateProvider.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateProvider: OnCreateProvider? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateProvider": onCreateProvider.flatMap { $0.snapshot }])
    }

    public var onCreateProvider: OnCreateProvider? {
      get {
        return (snapshot["onCreateProvider"] as? Snapshot).flatMap { OnCreateProvider(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateProvider")
      }
    }

    public struct OnCreateProvider: GraphQLSelectionSet {
      public static let possibleTypes = ["Provider"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("phoneNumber", type: .scalar(String.self)),
        GraphQLField("encounters", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, encounters: Encounter? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "encounters": encounters.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var phoneNumber: String? {
        get {
          return snapshot["phoneNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var encounters: Encounter? {
        get {
          return (snapshot["encounters"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounters")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelEncounterConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelEncounterConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnUpdateProviderSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateProvider($filter: ModelSubscriptionProviderFilterInput) {\n  onUpdateProvider(filter: $filter) {\n    __typename\n    id\n    firstName\n    lastName\n    phoneNumber\n    encounters {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionProviderFilterInput?

  public init(filter: ModelSubscriptionProviderFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateProvider", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateProvider.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateProvider: OnUpdateProvider? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateProvider": onUpdateProvider.flatMap { $0.snapshot }])
    }

    public var onUpdateProvider: OnUpdateProvider? {
      get {
        return (snapshot["onUpdateProvider"] as? Snapshot).flatMap { OnUpdateProvider(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateProvider")
      }
    }

    public struct OnUpdateProvider: GraphQLSelectionSet {
      public static let possibleTypes = ["Provider"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("phoneNumber", type: .scalar(String.self)),
        GraphQLField("encounters", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, encounters: Encounter? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "encounters": encounters.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var phoneNumber: String? {
        get {
          return snapshot["phoneNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var encounters: Encounter? {
        get {
          return (snapshot["encounters"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounters")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelEncounterConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelEncounterConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnDeleteProviderSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteProvider($filter: ModelSubscriptionProviderFilterInput) {\n  onDeleteProvider(filter: $filter) {\n    __typename\n    id\n    firstName\n    lastName\n    phoneNumber\n    encounters {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionProviderFilterInput?

  public init(filter: ModelSubscriptionProviderFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteProvider", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteProvider.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteProvider: OnDeleteProvider? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteProvider": onDeleteProvider.flatMap { $0.snapshot }])
    }

    public var onDeleteProvider: OnDeleteProvider? {
      get {
        return (snapshot["onDeleteProvider"] as? Snapshot).flatMap { OnDeleteProvider(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteProvider")
      }
    }

    public struct OnDeleteProvider: GraphQLSelectionSet {
      public static let possibleTypes = ["Provider"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
        GraphQLField("phoneNumber", type: .scalar(String.self)),
        GraphQLField("encounters", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, encounters: Encounter? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "encounters": encounters.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var firstName: String? {
        get {
          return snapshot["firstName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return snapshot["lastName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastName")
        }
      }

      public var phoneNumber: String? {
        get {
          return snapshot["phoneNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      public var encounters: Encounter? {
        get {
          return (snapshot["encounters"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounters")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelEncounterConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelEncounterConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnCreateEncounterSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateEncounter($filter: ModelSubscriptionEncounterFilterInput) {\n  onCreateEncounter(filter: $filter) {\n    __typename\n    id\n    scans {\n      __typename\n      nextToken\n    }\n    vaccines {\n      __typename\n      nextToken\n    }\n    provider {\n      __typename\n      id\n      firstName\n      lastName\n      phoneNumber\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    providerEncountersId\n  }\n}"

  public var filter: ModelSubscriptionEncounterFilterInput?

  public init(filter: ModelSubscriptionEncounterFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateEncounter", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateEncounter.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateEncounter: OnCreateEncounter? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateEncounter": onCreateEncounter.flatMap { $0.snapshot }])
    }

    public var onCreateEncounter: OnCreateEncounter? {
      get {
        return (snapshot["onCreateEncounter"] as? Snapshot).flatMap { OnCreateEncounter(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateEncounter")
      }
    }

    public struct OnCreateEncounter: GraphQLSelectionSet {
      public static let possibleTypes = ["Encounter"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("scans", type: .object(Scan.selections)),
        GraphQLField("vaccines", type: .object(Vaccine.selections)),
        GraphQLField("provider", type: .object(Provider.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, scans: Scan? = nil, vaccines: Vaccine? = nil, provider: Provider? = nil, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Encounter", "id": id, "scans": scans.flatMap { $0.snapshot }, "vaccines": vaccines.flatMap { $0.snapshot }, "provider": provider.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var scans: Scan? {
        get {
          return (snapshot["scans"] as? Snapshot).flatMap { Scan(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "scans")
        }
      }

      public var vaccines: Vaccine? {
        get {
          return (snapshot["vaccines"] as? Snapshot).flatMap { Vaccine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccines")
        }
      }

      public var provider: Provider? {
        get {
          return (snapshot["provider"] as? Snapshot).flatMap { Provider(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "provider")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var providerEncountersId: GraphQLID? {
        get {
          return snapshot["providerEncountersId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "providerEncountersId")
        }
      }

      public struct Scan: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelScanConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelScanConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Vaccine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVaccineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVaccineConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Provider: GraphQLSelectionSet {
        public static let possibleTypes = ["Provider"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("phoneNumber", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public var phoneNumber: String? {
          get {
            return snapshot["phoneNumber"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnUpdateEncounterSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateEncounter($filter: ModelSubscriptionEncounterFilterInput) {\n  onUpdateEncounter(filter: $filter) {\n    __typename\n    id\n    scans {\n      __typename\n      nextToken\n    }\n    vaccines {\n      __typename\n      nextToken\n    }\n    provider {\n      __typename\n      id\n      firstName\n      lastName\n      phoneNumber\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    providerEncountersId\n  }\n}"

  public var filter: ModelSubscriptionEncounterFilterInput?

  public init(filter: ModelSubscriptionEncounterFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateEncounter", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateEncounter.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateEncounter: OnUpdateEncounter? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateEncounter": onUpdateEncounter.flatMap { $0.snapshot }])
    }

    public var onUpdateEncounter: OnUpdateEncounter? {
      get {
        return (snapshot["onUpdateEncounter"] as? Snapshot).flatMap { OnUpdateEncounter(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateEncounter")
      }
    }

    public struct OnUpdateEncounter: GraphQLSelectionSet {
      public static let possibleTypes = ["Encounter"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("scans", type: .object(Scan.selections)),
        GraphQLField("vaccines", type: .object(Vaccine.selections)),
        GraphQLField("provider", type: .object(Provider.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, scans: Scan? = nil, vaccines: Vaccine? = nil, provider: Provider? = nil, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Encounter", "id": id, "scans": scans.flatMap { $0.snapshot }, "vaccines": vaccines.flatMap { $0.snapshot }, "provider": provider.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var scans: Scan? {
        get {
          return (snapshot["scans"] as? Snapshot).flatMap { Scan(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "scans")
        }
      }

      public var vaccines: Vaccine? {
        get {
          return (snapshot["vaccines"] as? Snapshot).flatMap { Vaccine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccines")
        }
      }

      public var provider: Provider? {
        get {
          return (snapshot["provider"] as? Snapshot).flatMap { Provider(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "provider")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var providerEncountersId: GraphQLID? {
        get {
          return snapshot["providerEncountersId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "providerEncountersId")
        }
      }

      public struct Scan: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelScanConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelScanConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Vaccine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVaccineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVaccineConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Provider: GraphQLSelectionSet {
        public static let possibleTypes = ["Provider"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("phoneNumber", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public var phoneNumber: String? {
          get {
            return snapshot["phoneNumber"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnDeleteEncounterSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteEncounter($filter: ModelSubscriptionEncounterFilterInput) {\n  onDeleteEncounter(filter: $filter) {\n    __typename\n    id\n    scans {\n      __typename\n      nextToken\n    }\n    vaccines {\n      __typename\n      nextToken\n    }\n    provider {\n      __typename\n      id\n      firstName\n      lastName\n      phoneNumber\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    providerEncountersId\n  }\n}"

  public var filter: ModelSubscriptionEncounterFilterInput?

  public init(filter: ModelSubscriptionEncounterFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteEncounter", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteEncounter.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteEncounter: OnDeleteEncounter? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteEncounter": onDeleteEncounter.flatMap { $0.snapshot }])
    }

    public var onDeleteEncounter: OnDeleteEncounter? {
      get {
        return (snapshot["onDeleteEncounter"] as? Snapshot).flatMap { OnDeleteEncounter(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteEncounter")
      }
    }

    public struct OnDeleteEncounter: GraphQLSelectionSet {
      public static let possibleTypes = ["Encounter"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("scans", type: .object(Scan.selections)),
        GraphQLField("vaccines", type: .object(Vaccine.selections)),
        GraphQLField("provider", type: .object(Provider.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, scans: Scan? = nil, vaccines: Vaccine? = nil, provider: Provider? = nil, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Encounter", "id": id, "scans": scans.flatMap { $0.snapshot }, "vaccines": vaccines.flatMap { $0.snapshot }, "provider": provider.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var scans: Scan? {
        get {
          return (snapshot["scans"] as? Snapshot).flatMap { Scan(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "scans")
        }
      }

      public var vaccines: Vaccine? {
        get {
          return (snapshot["vaccines"] as? Snapshot).flatMap { Vaccine(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccines")
        }
      }

      public var provider: Provider? {
        get {
          return (snapshot["provider"] as? Snapshot).flatMap { Provider(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "provider")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var providerEncountersId: GraphQLID? {
        get {
          return snapshot["providerEncountersId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "providerEncountersId")
        }
      }

      public struct Scan: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelScanConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelScanConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Vaccine: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelVaccineConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelVaccineConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Provider: GraphQLSelectionSet {
        public static let possibleTypes = ["Provider"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("phoneNumber", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Provider", "id": id, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return snapshot["firstName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return snapshot["lastName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastName")
          }
        }

        public var phoneNumber: String? {
          get {
            return snapshot["phoneNumber"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnCreateVaccineSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateVaccine($filter: ModelSubscriptionVaccineFilterInput) {\n  onCreateVaccine(filter: $filter) {\n    __typename\n    id\n    lotNumber\n    expirationDate\n    vaccineType {\n      __typename\n      id\n      name\n      createdAt\n      updatedAt\n    }\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterVaccinesId\n  }\n}"

  public var filter: ModelSubscriptionVaccineFilterInput?

  public init(filter: ModelSubscriptionVaccineFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateVaccine", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateVaccine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateVaccine: OnCreateVaccine? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateVaccine": onCreateVaccine.flatMap { $0.snapshot }])
    }

    public var onCreateVaccine: OnCreateVaccine? {
      get {
        return (snapshot["onCreateVaccine"] as? Snapshot).flatMap { OnCreateVaccine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateVaccine")
      }
    }

    public struct OnCreateVaccine: GraphQLSelectionSet {
      public static let possibleTypes = ["Vaccine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("lotNumber", type: .scalar(String.self)),
        GraphQLField("expirationDate", type: .scalar(String.self)),
        GraphQLField("vaccineType", type: .object(VaccineType.selections)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterVaccinesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, lotNumber: String? = nil, expirationDate: String? = nil, vaccineType: VaccineType? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterVaccinesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Vaccine", "id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "vaccineType": vaccineType.flatMap { $0.snapshot }, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterVaccinesId": encounterVaccinesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var lotNumber: String? {
        get {
          return snapshot["lotNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lotNumber")
        }
      }

      public var expirationDate: String? {
        get {
          return snapshot["expirationDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "expirationDate")
        }
      }

      public var vaccineType: VaccineType? {
        get {
          return (snapshot["vaccineType"] as? Snapshot).flatMap { VaccineType(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccineType")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterVaccinesId: GraphQLID? {
        get {
          return snapshot["encounterVaccinesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterVaccinesId")
        }
      }

      public struct VaccineType: GraphQLSelectionSet {
        public static let possibleTypes = ["VaccineType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return snapshot["name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class OnUpdateVaccineSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateVaccine($filter: ModelSubscriptionVaccineFilterInput) {\n  onUpdateVaccine(filter: $filter) {\n    __typename\n    id\n    lotNumber\n    expirationDate\n    vaccineType {\n      __typename\n      id\n      name\n      createdAt\n      updatedAt\n    }\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterVaccinesId\n  }\n}"

  public var filter: ModelSubscriptionVaccineFilterInput?

  public init(filter: ModelSubscriptionVaccineFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateVaccine", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateVaccine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateVaccine: OnUpdateVaccine? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateVaccine": onUpdateVaccine.flatMap { $0.snapshot }])
    }

    public var onUpdateVaccine: OnUpdateVaccine? {
      get {
        return (snapshot["onUpdateVaccine"] as? Snapshot).flatMap { OnUpdateVaccine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateVaccine")
      }
    }

    public struct OnUpdateVaccine: GraphQLSelectionSet {
      public static let possibleTypes = ["Vaccine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("lotNumber", type: .scalar(String.self)),
        GraphQLField("expirationDate", type: .scalar(String.self)),
        GraphQLField("vaccineType", type: .object(VaccineType.selections)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterVaccinesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, lotNumber: String? = nil, expirationDate: String? = nil, vaccineType: VaccineType? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterVaccinesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Vaccine", "id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "vaccineType": vaccineType.flatMap { $0.snapshot }, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterVaccinesId": encounterVaccinesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var lotNumber: String? {
        get {
          return snapshot["lotNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lotNumber")
        }
      }

      public var expirationDate: String? {
        get {
          return snapshot["expirationDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "expirationDate")
        }
      }

      public var vaccineType: VaccineType? {
        get {
          return (snapshot["vaccineType"] as? Snapshot).flatMap { VaccineType(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccineType")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterVaccinesId: GraphQLID? {
        get {
          return snapshot["encounterVaccinesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterVaccinesId")
        }
      }

      public struct VaccineType: GraphQLSelectionSet {
        public static let possibleTypes = ["VaccineType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return snapshot["name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class OnDeleteVaccineSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteVaccine($filter: ModelSubscriptionVaccineFilterInput) {\n  onDeleteVaccine(filter: $filter) {\n    __typename\n    id\n    lotNumber\n    expirationDate\n    vaccineType {\n      __typename\n      id\n      name\n      createdAt\n      updatedAt\n    }\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterVaccinesId\n  }\n}"

  public var filter: ModelSubscriptionVaccineFilterInput?

  public init(filter: ModelSubscriptionVaccineFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteVaccine", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteVaccine.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteVaccine: OnDeleteVaccine? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteVaccine": onDeleteVaccine.flatMap { $0.snapshot }])
    }

    public var onDeleteVaccine: OnDeleteVaccine? {
      get {
        return (snapshot["onDeleteVaccine"] as? Snapshot).flatMap { OnDeleteVaccine(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteVaccine")
      }
    }

    public struct OnDeleteVaccine: GraphQLSelectionSet {
      public static let possibleTypes = ["Vaccine"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("lotNumber", type: .scalar(String.self)),
        GraphQLField("expirationDate", type: .scalar(String.self)),
        GraphQLField("vaccineType", type: .object(VaccineType.selections)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterVaccinesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, lotNumber: String? = nil, expirationDate: String? = nil, vaccineType: VaccineType? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterVaccinesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Vaccine", "id": id, "lotNumber": lotNumber, "expirationDate": expirationDate, "vaccineType": vaccineType.flatMap { $0.snapshot }, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterVaccinesId": encounterVaccinesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var lotNumber: String? {
        get {
          return snapshot["lotNumber"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lotNumber")
        }
      }

      public var expirationDate: String? {
        get {
          return snapshot["expirationDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "expirationDate")
        }
      }

      public var vaccineType: VaccineType? {
        get {
          return (snapshot["vaccineType"] as? Snapshot).flatMap { VaccineType(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "vaccineType")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterVaccinesId: GraphQLID? {
        get {
          return snapshot["encounterVaccinesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterVaccinesId")
        }
      }

      public struct VaccineType: GraphQLSelectionSet {
        public static let possibleTypes = ["VaccineType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return snapshot["name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class OnCreateVaccineTypeSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateVaccineType($filter: ModelSubscriptionVaccineTypeFilterInput) {\n  onCreateVaccineType(filter: $filter) {\n    __typename\n    id\n    name\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionVaccineTypeFilterInput?

  public init(filter: ModelSubscriptionVaccineTypeFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateVaccineType", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateVaccineType.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateVaccineType: OnCreateVaccineType? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateVaccineType": onCreateVaccineType.flatMap { $0.snapshot }])
    }

    public var onCreateVaccineType: OnCreateVaccineType? {
      get {
        return (snapshot["onCreateVaccineType"] as? Snapshot).flatMap { OnCreateVaccineType(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateVaccineType")
      }
    }

    public struct OnCreateVaccineType: GraphQLSelectionSet {
      public static let possibleTypes = ["VaccineType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnUpdateVaccineTypeSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateVaccineType($filter: ModelSubscriptionVaccineTypeFilterInput) {\n  onUpdateVaccineType(filter: $filter) {\n    __typename\n    id\n    name\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionVaccineTypeFilterInput?

  public init(filter: ModelSubscriptionVaccineTypeFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateVaccineType", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateVaccineType.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateVaccineType: OnUpdateVaccineType? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateVaccineType": onUpdateVaccineType.flatMap { $0.snapshot }])
    }

    public var onUpdateVaccineType: OnUpdateVaccineType? {
      get {
        return (snapshot["onUpdateVaccineType"] as? Snapshot).flatMap { OnUpdateVaccineType(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateVaccineType")
      }
    }

    public struct OnUpdateVaccineType: GraphQLSelectionSet {
      public static let possibleTypes = ["VaccineType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnDeleteVaccineTypeSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteVaccineType($filter: ModelSubscriptionVaccineTypeFilterInput) {\n  onDeleteVaccineType(filter: $filter) {\n    __typename\n    id\n    name\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionVaccineTypeFilterInput?

  public init(filter: ModelSubscriptionVaccineTypeFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteVaccineType", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteVaccineType.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteVaccineType: OnDeleteVaccineType? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteVaccineType": onDeleteVaccineType.flatMap { $0.snapshot }])
    }

    public var onDeleteVaccineType: OnDeleteVaccineType? {
      get {
        return (snapshot["onDeleteVaccineType"] as? Snapshot).flatMap { OnDeleteVaccineType(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteVaccineType")
      }
    }

    public struct OnDeleteVaccineType: GraphQLSelectionSet {
      public static let possibleTypes = ["VaccineType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "VaccineType", "id": id, "name": name, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnCreateScanSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateScan($filter: ModelSubscriptionScanFilterInput) {\n  onCreateScan(filter: $filter) {\n    __typename\n    id\n    fileName\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterScansId\n  }\n}"

  public var filter: ModelSubscriptionScanFilterInput?

  public init(filter: ModelSubscriptionScanFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateScan", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateScan.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateScan: OnCreateScan? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateScan": onCreateScan.flatMap { $0.snapshot }])
    }

    public var onCreateScan: OnCreateScan? {
      get {
        return (snapshot["onCreateScan"] as? Snapshot).flatMap { OnCreateScan(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateScan")
      }
    }

    public struct OnCreateScan: GraphQLSelectionSet {
      public static let possibleTypes = ["Scan"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("fileName", type: .scalar(String.self)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterScansId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, fileName: String? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterScansId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Scan", "id": id, "fileName": fileName, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterScansId": encounterScansId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var fileName: String? {
        get {
          return snapshot["fileName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fileName")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterScansId: GraphQLID? {
        get {
          return snapshot["encounterScansId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterScansId")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class OnUpdateScanSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateScan($filter: ModelSubscriptionScanFilterInput) {\n  onUpdateScan(filter: $filter) {\n    __typename\n    id\n    fileName\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterScansId\n  }\n}"

  public var filter: ModelSubscriptionScanFilterInput?

  public init(filter: ModelSubscriptionScanFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateScan", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateScan.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateScan: OnUpdateScan? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateScan": onUpdateScan.flatMap { $0.snapshot }])
    }

    public var onUpdateScan: OnUpdateScan? {
      get {
        return (snapshot["onUpdateScan"] as? Snapshot).flatMap { OnUpdateScan(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateScan")
      }
    }

    public struct OnUpdateScan: GraphQLSelectionSet {
      public static let possibleTypes = ["Scan"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("fileName", type: .scalar(String.self)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterScansId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, fileName: String? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterScansId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Scan", "id": id, "fileName": fileName, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterScansId": encounterScansId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var fileName: String? {
        get {
          return snapshot["fileName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fileName")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterScansId: GraphQLID? {
        get {
          return snapshot["encounterScansId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterScansId")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}

public final class OnDeleteScanSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteScan($filter: ModelSubscriptionScanFilterInput) {\n  onDeleteScan(filter: $filter) {\n    __typename\n    id\n    fileName\n    encounter {\n      __typename\n      id\n      createdAt\n      updatedAt\n      providerEncountersId\n    }\n    createdAt\n    updatedAt\n    encounterScansId\n  }\n}"

  public var filter: ModelSubscriptionScanFilterInput?

  public init(filter: ModelSubscriptionScanFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteScan", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteScan.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteScan: OnDeleteScan? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteScan": onDeleteScan.flatMap { $0.snapshot }])
    }

    public var onDeleteScan: OnDeleteScan? {
      get {
        return (snapshot["onDeleteScan"] as? Snapshot).flatMap { OnDeleteScan(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteScan")
      }
    }

    public struct OnDeleteScan: GraphQLSelectionSet {
      public static let possibleTypes = ["Scan"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("fileName", type: .scalar(String.self)),
        GraphQLField("encounter", type: .object(Encounter.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("encounterScansId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, fileName: String? = nil, encounter: Encounter? = nil, createdAt: String, updatedAt: String, encounterScansId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Scan", "id": id, "fileName": fileName, "encounter": encounter.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "encounterScansId": encounterScansId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var fileName: String? {
        get {
          return snapshot["fileName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fileName")
        }
      }

      public var encounter: Encounter? {
        get {
          return (snapshot["encounter"] as? Snapshot).flatMap { Encounter(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "encounter")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var encounterScansId: GraphQLID? {
        get {
          return snapshot["encounterScansId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "encounterScansId")
        }
      }

      public struct Encounter: GraphQLSelectionSet {
        public static let possibleTypes = ["Encounter"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("providerEncountersId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String, providerEncountersId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Encounter", "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "providerEncountersId": providerEncountersId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var providerEncountersId: GraphQLID? {
          get {
            return snapshot["providerEncountersId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "providerEncountersId")
          }
        }
      }
    }
  }
}