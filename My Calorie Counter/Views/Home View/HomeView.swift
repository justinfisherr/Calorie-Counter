import SwiftUI


struct HomeView: View {
    @ObservedObject  var dataManager: DataManager
    @StateObject private var viewModel:HomeViewModel
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self._viewModel = StateObject(wrappedValue: HomeViewModel(dataManager: dataManager)) // Initialize viewModel in init
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Text("My Calorie Counter")
                    .font(.largeTitle)
                    .padding()
                if(dataManager.tdee == 0){
                    Text("Set a goal to start counting!")
                    NavigationLink("Set Goals", destination: Goals(dataManager: dataManager))
                }else{
                    Text("Calories Consumed: \(Int(viewModel.caloriesConsumed)) / \(Int(dataManager.tdee))")
                    
                    ProgressBar(value: viewModel.caloriesConsumed, maxValue: dataManager.tdee)
                        .frame(width: 200, height: 20)
                        .padding()
                    
                    TextField("Enter Calories", text: $viewModel.caloriesInput)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit{viewModel.addCalories()}
                        .keyboardType(.numberPad)
                    
                    Button("Add Calories") {
                        // Validate input and convert to integer
                        viewModel.addCalories()
                    }
                    .padding()
                    
                    NavigationLink("Change Goals", destination: Goals(dataManager: dataManager))

                    
                    
                    // Make the list scrollable
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.inputs, id: \.self) { entry in
                                Text("\(entry.timestamp, formatter: viewModel.dateFormatter) - Calories: \(entry.calorieAmount)")
                            }
                        }
                    }
                    .frame(height: 100) // Limit the height of the ScrollView
                }
                }
                
            .padding()
        }
    }
    

    
    struct ProgressBar: View {
        var value: Double
        var maxValue: Double
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                    
                    Rectangle()
                        .frame(width: min(CGFloat(self.value / self.maxValue) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                        .foregroundColor(Color.green)
                        .animation(Animation.linear)
                }
            }
        }
    }
    
    
}
#Preview {
    HomeView(dataManager: DataManager())
}
