//
//  OnboardingView.swift
//  nerve-v2
//
//  Created by Thomas Wang on 1/6/24.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("VacScan")
                
                Spacer()
                    .frame(width: 0, height: 100)
                
                Button {
                    path.append(OnboardingInputEnum.phoneNumber)
                } label:  {
                    Text("Sign In")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding([.leading, .trailing], 20)
                        .padding([.top, .bottom], 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.blue, lineWidth: 1)
                            
                        )
                }
                .padding(.bottom, 17.5)
            }
            .navigationDestination(for: OnboardingInputEnum.self){ view in
                OnboardingInputView(view: view, path: $path)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
            .multilineTextAlignment(.center)
        }
    }
}
