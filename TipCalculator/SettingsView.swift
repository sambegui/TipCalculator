//
//  SettingsView.swift
//  TipCalculator
//
//  Created by Samuel Beguiristain on 10/1/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Binding var darkThemeEnabled: Bool

    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $darkThemeEnabled) {
                    Text("Dark Theme")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(darkThemeEnabled: .constant(false))
    }
}
