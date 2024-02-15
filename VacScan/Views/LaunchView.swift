//
//  LaunchView.swift
//  VacScan
//
//  Created by Thomas Wang on 2/15/24.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.isSignedIn == nil {
            Text("VacScan")
                .task{
                    await authManager.fetchCurrentUser()
                }
        } else if authManager.isSignedIn! {
            HomeView()
        } else {
            OnboardingWelcomeView()
        }
    }
}

#Preview {
    LaunchView()
}
