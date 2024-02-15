//
//  Onboarding.swift
//  nerve-v2
//
//  Created by Thomas Wang on 1/7/24.
//

import SwiftUI
import Amplify
import Combine

enum OnboardingInputEnum {
    case phoneNumber
    case verificationCode
    case firstName
    case lastName
    
    func validateInput(input: String) -> Bool{
        switch self {
        case .phoneNumber:
            return input.filter{ $0.isNumber }.count == 10
        case .verificationCode:
            return input.count == 6
        case .firstName:
            return false
        case .lastName:
            return false
        }
    }
    
    func getUserPrompt() -> String{
        switch self {
        case .phoneNumber:
            return "What's your phone number?"
        case .verificationCode:
            return "Enter the code we just texted you"
        case .firstName:
            return "What's your first name?"
        case .lastName:
            return "What's your last name?"
        }
    }
    
    func getTextfieldPlaceholder() -> String {
        switch self {
        case .phoneNumber:
            return "(123) 456-7890"
        case .verificationCode:
            return "123456"
        case .firstName:
            return "John"
        case .lastName:
            return "Smith"
        }
    }
    
    func getKeyboardType() -> UIKeyboardType {
        switch self{
        case .phoneNumber:
            return .phonePad
        case .verificationCode:
            return .numberPad
        case .firstName, .lastName:
            return .default
        }
    }
    
    func getTextContentType() -> UITextContentType {
        switch self {
        case .phoneNumber:
            return .telephoneNumber
        case .verificationCode:
            return .oneTimeCode
        case .firstName:
            return .givenName
        case .lastName:
            return .familyName
        }
    }
    
    func getNextScreen() -> OnboardingInputEnum?{
        switch self{
        case .phoneNumber:
            return .verificationCode
        case .verificationCode:
            return .firstName
        case .firstName:
            return .lastName
        case .lastName:
            return nil
        }
    }
}
