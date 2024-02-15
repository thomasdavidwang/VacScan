//
//  VacScanApp.swift
//  VacScan
//
//  Created by Thomas Wang on 1/24/24.
//

import SwiftUI
import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin

@main
struct VacScanApp: App {
    @StateObject var authManager = AuthManager()
    
    init() {
        do {
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Initialized Amplify");
        } catch {
            // simplified error handling for the tutorial
            print("Could not initialize Amplify: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(authManager)
        }
    }
}
