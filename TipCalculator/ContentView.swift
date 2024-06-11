import SwiftUI

struct ContentView: View {
    @State private var billAmount = ""
    @State private var tipPercentage = 15
    @State private var numberOfPeople = ""
    @State private var individualShare: Double = 0
    @State private var isShowingSettings = false
    @State private var darkThemeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    @State private var includeTipInShare = true
    @State private var tipOptions = [5, 10, 15, 20]
    @State private var selectedTipIndex = 1
    @State private var usePredefinedTips = UserDefaults.standard.bool(forKey: "usePredefinedTips")
    
    func calculateShare() {
        if usePredefinedTips {
            tipPercentage = tipOptions[selectedTipIndex]
        }
        
        let peopleCount = Double(numberOfPeople) ?? 1
        individualShare = includeTipInShare ? totalBill / peopleCount : (totalBill - tipValue) / peopleCount
    }

    var tipValue: Double {
        let bill = Double(billAmount) ?? 0
        return bill * Double(tipPercentage) / 100
    }
    
    var totalBill: Double {
        let bill = Double(billAmount) ?? 0
        return bill + tipValue
    }
    
    func billAmountSection() -> some View {
        Section(header: Text("Bill Amount")) {
            TextField("Enter amount", text: $billAmount)
                .keyboardType(.decimalPad)
        }
    }
    
    func numberOfPeopleSection() -> some View {
        Section(header: Text("Number of People")) {
            HStack {
                TextField("Enter number of people", text: $numberOfPeople)
                    .keyboardType(.numberPad)
                    .onChange(of: numberOfPeople) { _ in calculateShare() }
                peopleIcon()
            }
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
    
    var body: some View {
        NavigationView {
            Form {
                billAmountSection()
                
                numberOfPeopleSection()
                
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
                            Slider(value: Binding(get: {
                                Double(self.tipPercentage)
                            }, set: { newValue in
                                self.tipPercentage = Int(newValue)
                                calculateShare()
                            }), in: 0...100, step: 1)
                            .accentColor(.blue)
                            HStack {
                                Text("Tip: \(tipPercentage)%")
                                Spacer()
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
        .onChange(of: darkThemeEnabled) { (value) in
            UserDefaults.standard.set(value, forKey: "darkModeEnabled")
        }
        .onChange(of: usePredefinedTips) { (value) in
            UserDefaults.standard.set(value, forKey: "usePredefinedTips")
        }
        .hideKeyboardOnTap()
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
