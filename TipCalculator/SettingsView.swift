import SwiftUI

struct SettingsView: View {
    @Binding var darkThemeEnabled: Bool
    @Binding var includeTipInShare: Bool
    @Binding var selectedTipIndex: Int
    @Binding var usePredefinedTips: Bool
    let tipOptions: [Int]
    
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
                    
                    if usePredefinedTips {
                        Picker("Tip Options", selection: $selectedTipIndex) {
                            ForEach(0..<tipOptions.count) { index in
                                Text("\(tipOptions[index])%")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Spacer()
                
                Text("Made with ♡ by Samuel Beguiristain")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .navigationTitle("Settings")
        }
        .environment(\.colorScheme, darkThemeEnabled ? .dark : .light)
    }
}
