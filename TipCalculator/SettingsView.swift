import SwiftUI

struct SettingsView: View {
    @Binding var darkThemeEnabled: Bool

    var body: some View {
        Form {
            Toggle(isOn: $darkThemeEnabled) {
                Text("Dark Theme")
            }
        }
        .navigationTitle("Settings")
    }
}
