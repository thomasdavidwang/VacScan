//
//  ContentView.swift
//  VacScan
//
//  Created by Thomas Wang on 1/24/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var scanManager: ScanManager
    @EnvironmentObject var authManager: AuthManager
    
    @State private var recognizedText = "Tap button to start scanning."
    @State private var scans = [UIImage]()
    @State private var showingScanningView = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("VacScan")
                    
                    Spacer()
                    
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "person.circle")
                    }
                }.padding()
                
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.gray.opacity(0.2))
                        
                        Text(recognizedText)
                            .padding()
                    }
                    .padding()
                }
                
                Button(action: {
                    Task {
                        await scanManager.saveScansToBackend(scans: scans, provider: authManager.provider)
                    }
                }) {
                    Text("Upload")
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.showingScanningView = true
                    }) {
                        Text("Start Scanning")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Capsule().fill(Color.blue))
                }
                .padding()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(showSettings: self.$showSettings)
            }
            .sheet(isPresented: $showingScanningView) {
                ScanView(scans: self.$scans, recognizedText: self.$recognizedText)
            }
        }
    }
}
