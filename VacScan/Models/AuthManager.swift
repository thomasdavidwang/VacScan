//
//  AuthManager.swift
//  VacScan
//
//  Created by Thomas Wang on 2/15/24.
//

import Foundation
import Amplify
import Combine
import AWSCognitoAuthPlugin

class AuthManager: ObservableObject {
    @Published var provider: Provider = Provider()
    @Published var isSignedIn: Bool?
    
    init() {
    }
    
    func fetchCurrentUser() async{
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
                        
            await MainActor.run {
                self.isSignedIn = session.isSignedIn
            }
            
            if session.isSignedIn {
                let userAttributes = try await Amplify.Auth.fetchUserAttributes()
                for attribute in userAttributes {
                    if attribute.key == .phoneNumber {
                                                
                        let matchingProviders = try await getProviderByPhone(phoneNumber: attribute.value)
                        if(matchingProviders != nil && matchingProviders!.count > 0) {
                            await MainActor.run {
                                self.provider = matchingProviders![0]
                            }
                        }
                    }
                }
            }
        } catch {
            print("error fetching current auth session")
        }
    }
    
    func signUp(phoneNumber: String) async throws {
        let digits = "+1" + phoneNumber.filter{$0.isNumber}
        await MainActor.run {
            self.provider.phoneNumber = digits
        }
        
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: digits,
                password: UUID().uuidString
            )
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId)))")
            } else {
                print("Signup Complete")
            }
        } catch let error as AuthError {
            throw error
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func signOut() async throws{
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }

        print("Local signout successful: \(signOutResult.signedOutLocally)")
        switch signOutResult {
            case .complete:
                // Sign Out completed fully and without errors.
                print("Signed out successfully")

            case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
                // Sign Out completed with some errors. User is signed out of the device.
                print("Partial sign out")

            case .failed(let error):
                // Sign Out failed with an exception, leaving the user signed in.
                print("SignOut failed with \(error)")
        }
        
        await MainActor.run{
            self.isSignedIn = false
        }
    }
    
    func confirmSignUp(for phoneNumber: String, with confirmationCode: String) async throws {
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: phoneNumber,
                confirmationCode: confirmationCode
            )
            print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
        } catch let error as AuthError {
            throw error
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func signIn(phoneNumber: String) async throws {
        do {
            let options = AWSAuthSignInOptions(authFlowType: .customWithoutSRP)
            let signInResult = try await Amplify.Auth.signIn(username: phoneNumber,
                                                            options: .init(pluginOptions: options))
            if case .confirmSignInWithCustomChallenge(_) = signInResult.nextStep {
                // Ask the user to enter the custom challenge.
            } else {
                print("Sign in succeeded")
            }
        } catch let error as AuthError {
            throw error
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func confirmSignIn(response: String) async throws {
        do {
            _ = try await Amplify.Auth.confirmSignIn(challengeResponse: response)
            print("Confirm sign in succeeded")
        } catch let error as AuthError {
            throw error
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func createUserInBackend() async throws {
        do {
            let result = try await Amplify.API.mutate(request: .create(provider))
            switch result {
            case .success(let user):
                print("Successfully created user: \(user)")
            case .failure(let graphQLError):
                print("Failed to create graphql \(graphQLError)")
            }
        } catch let error as APIError {
            throw error
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func updateUserInBackend() async throws {
        do {
            let result = try await Amplify.API.mutate(request: .update(provider))
            switch result {
            case .success(let user):
                print("Successfully updated user: \(user)")
            case .failure(let graphQLError):
                print("Failed to create graphql \(graphQLError)")
            }
        } catch let error as APIError {
            throw error
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    #warning("Use secondary indices")
    func getProviderByPhone(phoneNumber: String) async throws -> List<Provider>?{
        do {
            let provider = Provider.keys
            let predicate = provider.phoneNumber == phoneNumber
            let request = GraphQLRequest<Provider>.list(Provider.self, where: predicate)
            let result = try await Amplify.API.query(request: request)
            switch result {
                case .success(let users):
                    print("Successfully retrieved user: \(users)")
                    return users
                case .failure(let error):
                    throw error
                }
        } catch let error as APIError {
            throw error
        } catch {
            print("Unexpected error: \(error)")
        }
        return nil
    }
}
