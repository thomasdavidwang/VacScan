//
//  ContentView.swift
//  VacScan
//
//  Created by Thomas Wang on 1/24/24.
//

import SwiftUI

struct HomeView: View {
    @State private var recognizedText = "Tap button to start scanning."
    @State private var showingScanningView = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.gray.opacity(0.2))
                        
                        Text(recognizedText)
                            .padding()
                    }
                    .padding()
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
            .navigationBarTitle("Text Recognition")
            .sheet(isPresented: $showingScanningView) {
                        ScanView(recognizedText: self.$recognizedText)
                    }
        }
    }
}
