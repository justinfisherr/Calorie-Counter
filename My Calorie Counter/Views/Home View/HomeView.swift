import SwiftUI

struct HomeView: View {
    @ObservedObject var dataManager: DataManager
    @StateObject private var viewModel: HomeViewModel

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self._viewModel = StateObject(wrappedValue: HomeViewModel(dataManager: dataManager)) // Initialize viewModel in init
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("My Calorie Counter")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.white) // Text color in dark mode

                if (dataManager.tdee == 0) {
                    Text("Set a goal to start counting!")
                    NavigationLink("Set Goals", destination: Goals(dataManager: dataManager))
                        .foregroundColor(.white) // Text color in dark mode
                } else {
                    Text("Calories Consumed: \(Int(viewModel.caloriesConsumed)) / \(Int(dataManager.tdee ?? 0.0))")
                        .foregroundColor(.white) // Text color in dark mode

                    ProgressBar(caloriesConsumed: viewModel.caloriesConsumed, tdee: dataManager.tdee ?? 0.0)

                    TextField("Enter Calories", text: $viewModel.caloriesInput)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit { viewModel.addCalories() }
                        .keyboardType(.numberPad)
                        .foregroundColor(.white) // Text color in dark mode

                    Button("Add Calories") {
                        // Validate input and convert to integer
                        viewModel.addCalories()
                    }
                    .padding()
                    .foregroundColor(.white) // Text color in dark mode

                    NavigationLink("Change Goals", destination: Goals(dataManager: dataManager))
                        .foregroundColor(.white) // Text color in dark mode

                    // Make the list scrollable
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.inputs, id: \.self) { entry in
                                Text("\(entry.timestamp, formatter: viewModel.dateFormatter) - Calories: \(entry.calorieAmount)")
                                    .foregroundColor(.white) // Text color in dark mode
                            }
                        }
                    }
                    .frame(height: 100) // Limit the height of the ScrollView
                }
            }
            .padding()
            .background(Color.black) // Set background color to black
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Adjust navigation view style for iPad
        .preferredColorScheme(.dark) // Set preferred color scheme to dark mode
    }
}

struct ProgressBar: View {
    var caloriesConsumed: Double
    var tdee: Double

    var body: some View {
        VStack {
            Spacer() // Add space at the top
            ZStack {
                Circle().stroke(Color.white.opacity(0.1), lineWidth: 20)

                let percentage = caloriesConsumed / tdee

                Circle()
                    .trim(from: 0, to: CGFloat(percentage))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))

                VStack {
                    Text("\(Int(caloriesConsumed)) / \(Int(tdee))")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white) // Text color in dark mode
                }
            }
            .padding(.horizontal, 50)
            Spacer() // Add space at the bottom
        }
    }
}

