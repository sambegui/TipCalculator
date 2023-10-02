//
//  DismissKeyboardModifier.swift
//  TipCalculator
//
//  Created by Samuel Beguiristain on 10/1/23.
//

import Foundation
import SwiftUI
struct DismissKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .map { $0 as? UIWindowScene }
                    .compactMap { $0 }
                    .first?.windows
                    .filter { $0.isKeyWindow }
                    .first
                
                keyWindow?.endEditing(true)
            }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboard())
    }
}
