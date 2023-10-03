
import SwiftUI

struct ContentView: View {
    @State private var billAmount = ""
    @State private var tipPercentage = 15
    @State private var numberOfPeople = 1
    @State private var individualShare: Double = 0
    @State private var isShowingSettings = false  // New state variable for the modal
    @State private var darkThemeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    @State private var includeTipInShare = true
    @State private var tipOptions = [5, 10, 15, 20]
    @State private var selectedTipIndex = 1  // Default to 15%
    @State private var usePredefinedTips = UserDefaults.standard.bool(forKey: "usePredefinedTips")



    
    // MARK: - Calculations
    func calculateShare() {
        // Debug print
        print("Selected tip index: \(selectedTipIndex)")
        print("Current tip percentage: \(tipPercentage)")

        // Update tipPercentage based on the selected index if predefined tips are used
        if usePredefinedTips {
            tipPercentage = tipOptions[selectedTipIndex]
        }
        
        individualShare = includeTipInShare ? totalBill / Double(numberOfPeople + 1) : (totalBill - tipValue) / Double(numberOfPeople + 1)
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
                
                // Number of People Picker
                Section(header: Text("Number of People")) {
                    HStack {
                        numberPickerWithLabel(title: "Number of People", label: "People", selection: $numberOfPeople, range: 1..<100)
                            .onChange(of: numberOfPeople) { _ in calculateShare() }
                        peopleIcon()
                    }
                }
                
                // Tip Percentage Picker
                Section(header: Text("Tip Percentage")) {
                    Group {
                        if usePredefinedTips {
                                Picker("", selection: $selectedTipIndex) {
                                    ForEach(0..<tipOptions.count) { index in
                                        Text("\(self.tipOptions[index])%")
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .onChange(of: selectedTipIndex) { _ in calculateShare() }
                        } else {
                            HStack {
                                numberPickerWithLabel(title: "Tip Percentage", label: "Tip", selection: $tipPercentage, range: 0..<100)
                                    .onChange(of: tipPercentage) { _ in calculateShare() }
                                tipIcon()
                            }
                        }
                    }
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
                SettingsView(
                    darkThemeEnabled: $darkThemeEnabled,
                    includeTipInShare: $includeTipInShare,
                    selectedTipIndex: $selectedTipIndex,
                    usePredefinedTips: $usePredefinedTips,
                    tipOptions: tipOptions
                )
            }
            .onChange(of: includeTipInShare) { _ in
                calculateShare()
            }
        }
        .environment(\.colorScheme, darkThemeEnabled ? .dark : .light)
        .onReceive([self.darkThemeEnabled].publisher.first()) { (value) in
            UserDefaults.standard.set(value, forKey: "darkModeEnabled")
        }
        .onReceive([self.usePredefinedTips].publisher.first()) { (value) in
            UserDefaults.standard.set(value, forKey: "usePredefinedTips")
        }
        .dismissKeyboardOnTap()
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
