//
//  PhoneNumberView.swift
//  nerve-v2
//
//  Created by Thomas Wang on 1/6/24.
//

import SwiftUI
import Combine
import Amplify

struct OnboardingInputView: View {
    let view: OnboardingInputEnum
    @Binding var path: NavigationPath
    @EnvironmentObject var authManager: AuthManager
    
    @State private var input: String = ""
    @State private var oldInput: String = ""
    @FocusState private var isFocused: Bool
    @State private var error: AmplifyError?
    @State private var isLoading: Bool = false
    
#warning("Would like to isolate the logic more in future, also some better way to conform to AWSPhone")
    func submitInput() async{
        self.isLoading = true
        isFocused = false
        do {
            switch view {
            case .phoneNumber:
                let digits = "+1" + input.filter{$0.isNumber}
                let provider = try await authManager.getProviderByPhone(phoneNumber: digits)
                if (provider!.count == 0) {
                    try await authManager.signUp(phoneNumber: input)
                    print("signed up")
                    try await authManager.createUserInBackend()
                    print("creating")
                } else {
                    await MainActor.run {
                        authManager.provider = provider![0]
                    }
                }
                try await authManager.signIn(phoneNumber: digits)
                path.append(view.getNextScreen()!)
            case .verificationCode:
                try await authManager.confirmSignIn(response: input)
                if authManager.provider.firstName == nil{
                    path.append(view.getNextScreen()!)
                } else {
                    await MainActor.run {
                        authManager.isSignedIn = true
                    }
                }
            case .firstName:
                await MainActor.run {
                    authManager.provider.firstName = input
                }
                path.append(view.getNextScreen()!)
            case .lastName:
                await MainActor.run {
                    authManager.provider.lastName = input
                }
                try await authManager.updateUserInBackend()
                await MainActor.run {
                    authManager.isSignedIn = true
                }
            }
        } catch let error as AmplifyError {
            self.isLoading = false
            self.error = error
        } catch {
            print("Error")
        }
        
        self.isLoading = false
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(view.getUserPrompt())
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 36)
                
                TextField("", text: $input)
                    .placeholder(when: input.isEmpty) {
                        Text(view.getTextfieldPlaceholder()).foregroundColor(.gray)
                    }
                    .keyboardType(view.getKeyboardType())
                    .textContentType(view.getTextContentType())
                    .onChange(of: input) { newInput in
                        if input.count - oldInput.count > 1 {
                            Task {
                                await submitInput()
                            }
                        } else {
                            if view.validateInput(input: input) {
                                Task{
                                    await submitInput()
                                }
                            }
                        }
                        oldInput = input
                    }
                    .onSubmit {
                        Task{
                            await submitInput()
                        }
                    }
                    .focused($isFocused)
                    .frame(width: 150)
            }
            .errorAlert(error: $error)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
            .multilineTextAlignment(.center)
            
            if isLoading {
                ProgressView()
            }
        }
        .task{
            await MainActor.run {
                self.isFocused = true
            }
        }
    }
}
