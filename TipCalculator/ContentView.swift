
import SwiftUI

struct ContentView: View {
    @State private var billAmount = ""
    @State private var tipPercentage = 15
    @State private var numberOfPeople = 1
    @State private var individualShare: Double = 0
    @State private var darkThemeEnabled = false
    @State private var isShowingSettings = false  // New state variable for the modal
    
    // MARK: - Calculations
    func calculateShare() {
        individualShare = totalBill / Double(numberOfPeople + 1)
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
    
    func numberPickerWithLabel(title: String, label: String, selection: Binding<Int>, range: Range<Int>) -> some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            Picker(title, selection: selection) {
                ForEach(range) {
                    Text("\($0)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)
        }
    }

    func tipIcon() -> some View {
        Image(systemName: "percent")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
    }
    
    func peopleIcon() -> some View {
        Image(systemName: "person.fill")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                billAmountSection()
                
                HStack {
                    numberPickerWithLabel(title: "Number of People", label: "People", selection: $numberOfPeople, range: 1..<100)
                            .onChange(of: numberOfPeople) { _ in calculateShare() }
                    peopleIcon()
                }
                
                HStack {
                    numberPickerWithLabel(title: "Tip Percentage", label: "Tip", selection: $tipPercentage, range: 0..<100)
                            .onChange(of: tipPercentage) { _ in calculateShare() }
                    tipIcon()
                }
                
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
                Button(action: {
                    self.isShowingSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                        .accessibilityLabel(Text("Settings"))
                }
            )
            .sheet(isPresented: $isShowingSettings) {
                SettingsView(darkThemeEnabled: $darkThemeEnabled)
            }
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
