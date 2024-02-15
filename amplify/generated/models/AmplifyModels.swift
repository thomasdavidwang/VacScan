// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "bd3163199ac114370d52e807ed7c7b4a"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Patient.self)
    ModelRegistry.register(modelType: Provider.self)
    ModelRegistry.register(modelType: Encounter.self)
    ModelRegistry.register(modelType: Vaccine.self)
    ModelRegistry.register(modelType: Scan.self)
  }
}