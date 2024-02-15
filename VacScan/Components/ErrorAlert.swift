//
//  ErrorAlert.swift
//  VacScan
//
//  Created by Thomas Wang on 2/15/24.
//

import SwiftUI
import Amplify

extension View {
    func errorAlert(error: Binding<AmplifyError?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
    
    func errorAlert(error: Binding<String>, subtitle: String, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue, subtitle: subtitle)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = ""
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
    
    
    
}

struct LocalizedAlertError: LocalizedError {
    var description: String
    var recovery: String
    
    var errorDescription: String? {
        self.description
    }
    
    var recoverySuggestion: String? {
        self.recovery
    }

    init?(error: AmplifyError?) {
        if (error != nil) {
            self.description = error?.errorDescription ?? ""
            self.recovery = error?.recoverySuggestion ?? ""
        } else {
            return nil
        }
    }
    
    init?(error: String, subtitle: String) {
        if error != "" {
            self.description = error
            self.recovery = subtitle
        } else {
            return nil
        }
    }
}
