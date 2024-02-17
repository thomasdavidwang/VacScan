//
//  SettingsView.swift
//  VacScan
//
//  Created by Thomas Wang on 2/16/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @Binding var showSettings: Bool
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    showSettings = false
                }){
                    Text("\(Image(systemName: "chevron.backward"))Back")
                }
                
                Spacer()
            }.padding()
            
            Spacer()

            Button(action: {
                Task {
                    try await authManager.signOut()
                }
            }){
                Text("Sign out")
            }
        }
    }
}
