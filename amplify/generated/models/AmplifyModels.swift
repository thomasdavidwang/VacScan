// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "1d2cf6319e44cc1bc0ba00441a1f9d0e"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Patient.self)
    ModelRegistry.register(modelType: Provider.self)
    ModelRegistry.register(modelType: Encounter.self)
    ModelRegistry.register(modelType: Vaccine.self)
    ModelRegistry.register(modelType: VaccineType.self)
    ModelRegistry.register(modelType: Scan.self)
  }
}