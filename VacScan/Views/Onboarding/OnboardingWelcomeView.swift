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
                Image("NerveLogo")
                
                Spacer()
                    .frame(width: 0, height: 100)
                
                Button {
                    path.append(OnboardingInputEnum.phoneNumber)
                } label:  {
                    Text("Play")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding([.leading, .trailing], 20)
                        .padding([.top, .bottom], 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.green, lineWidth: 1)
                            
                        )
                }
                .foregroundColor(.green)
                .padding(.bottom, 17.5)
                
                Link("By tapping \"Play\", you’re accepting the Terms and Privacy Policy.\n Click \"Terms\" or \"Privacy Policy\" to view them.", destination: URL(string: "https://sites.google.com/view/nerve-terms-of-service/home")!)
                    .font(.system(size: 8))
            }
            .navigationDestination(for: OnboardingInputEnum.self){ view in
                OnboardingInputView(view: view, path: $path)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
            .background(.black)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
        }
    }
}
