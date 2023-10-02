
import SwiftUI

struct ContentView: View {
    @State private var billAmount = ""
    @State private var tipPercentage = 15
    @State private var numberOfPeople = 1
    @State private var individualShare: Double = 0
    @State private var dyslexicFontEnabled = false
    @State private var darkThemeEnabled = false

    // MARK: - Calculations
    func calculateShare() {
        individualShare = totalBill / Double(numberOfPeople)
    }

    var tipValue: Double {
        let bill = Double(billAmount) ?? 0
        return bill * Double(tipPercentage) / 100
    }

    var totalBill: Double {
        let bill = Double(billAmount) ?? 0
        return bill + tipValue
    }

    // MARK: - UI Components
    func billAmountSection() -> some View {
        Section(header: Text("Bill Amount")) {
            TextField("Enter amount", text: $billAmount)
                .keyboardType(.decimalPad)
        }
    }
    
    func numberPicker(title: String, selection: Binding<Int>, range: Range<Int>) -> some View {
        Picker(title, selection: selection) {
            ForEach(range) {
                Text("\($0)")
            }
        }
        .pickerStyle(WheelPickerStyle())
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                billAmountSection()
                
                numberPicker(title: "Number of People", selection: $numberOfPeople, range: 1..<100)
                    .onChange(of: numberOfPeople) { _ in calculateShare() }
                
                numberPicker(title: "Tip Percentage", selection: $tipPercentage, range: 0..<100)
                    .onChange(of: tipPercentage) { _ in calculateShare() }
                
                Section(header: Text("Tip Amount")) {
                    Text("$\(tipValue, specifier: "%.2f")")
                }
                
                Section(header: Text("Total Amount")) {
                    Text("$\(totalBill, specifier: "%.2f")")
                }
                
                Section(header: Text("Individual Share")) {
                    Text("$\(individualShare, specifier: "%.2f")")
                        .onAppear { calculateShare() }
                }
            }
            .onChange(of: billAmount) { _ in calculateShare() }
            .navigationTitle("Tip Calculator")
            .navigationBarItems(trailing:
                NavigationLink(destination: SettingsView(darkThemeEnabled: $darkThemeEnabled)) {
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                        .accessibilityLabel(Text("Settings"))
                }
            )
        }
        .environment(\.colorScheme, darkThemeEnabled ? .dark : .light)
        .dismissKeyboardOnTap()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
