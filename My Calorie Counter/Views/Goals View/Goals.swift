import SwiftUI

struct Goals: View {
    @ObservedObject  var dataManager: DataManager
    @StateObject private var viewModel:GoalsViewModel
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self._viewModel = StateObject(wrappedValue: GoalsViewModel(dataManager: dataManager)) // Initialize viewModel in init
    }
    
    var body: some View {
        VStack {
            Text("Goals")
                .font(.largeTitle)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Current Weight (lbs)")
                TextField("Enter your current weight", text: $viewModel.currentWeightLbs)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.currentWeightLbs) { _,_ in
                        viewModel.updateSaveButtonState()
                    }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Height (cm)")
                TextField("Enter your height", text: $viewModel.heightCm)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.heightCm) { _,_ in
                        viewModel.updateSaveButtonState()
                    }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Age")
                TextField("Enter your age", text: $viewModel.age)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.age) { _,_ in
                        viewModel.updateSaveButtonState()
                    }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Activity Level")
                Picker("Activity Level", selection: $viewModel.activityLevel) {
                    ForEach(viewModel.activityLevels, id: \.self) { level in
                        Text(level)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewModel.activityLevel) { _,_ in
                    viewModel.updateSaveButtonState()
                }
            }

            Text("Your TDEE: \(Int(viewModel.tdee))")

            
            Button("Save", action: viewModel.saveGoals)
                .padding()
                .opacity(viewModel.isSaveEnabled ? 1.0 : 0.5)
                .disabled(!viewModel.isSaveEnabled)
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.loadUserData()
            viewModel.calculateTDEE()
        }
    }
    
    
    //Helper Methods Below
 
}

#Preview {
    Goals(dataManager: DataManager())
}
