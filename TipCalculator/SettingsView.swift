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
