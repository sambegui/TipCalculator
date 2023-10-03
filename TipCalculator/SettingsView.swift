import SwiftUI

struct SettingsView: View {
    @Binding var darkThemeEnabled: Bool
    @Binding var includeTipInShare: Bool  // New Binding variable
    @Binding var selectedTipIndex: Int  // New Binding variable for tip selection
    @Binding var usePredefinedTips: Bool  // New Binding variable
    let tipOptions: [Int]  // New constant array for tip options
    

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Toggle(isOn: $darkThemeEnabled) {
                        Text("Dark Theme")
                    }
                    Toggle(isOn: $includeTipInShare) {
                        Text("Include Tip in Individual Share")
                    }
                    Toggle(isOn: $usePredefinedTips) {
                        Text("Use Predefined Tip Values")
                    }
                }
                .navigationTitle("Settings")
            }
        }

        Text("Made with ♡ by Samuel Beguiristain")
            .font(.footnote)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}
