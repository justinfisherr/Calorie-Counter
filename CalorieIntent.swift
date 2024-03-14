import Foundation
import AppIntents



// Function to add calories to the consumed calories and store the entry
func addCalories()  {
    let caloriesConsumed = UserDefaults(suiteName: "group.com.calories.counter")?.double(forKey: "caloriesConsumed") ?? 0.0
    print(caloriesConsumed)
    
    var inputs: [CalorieEntry] = []
    
    // Retrieve previous entries
    if let savedEntriesData = UserDefaults(suiteName: "group.com.calories.counter")?.data(forKey: "calorieEntries"),
       let decodedEntries = try? JSONDecoder().decode([CalorieEntry].self, from: savedEntriesData) {
        inputs = decodedEntries
    }
    
    // Update consumed calories and add new entry
    let newCal = caloriesConsumed + 100
    inputs.append(CalorieEntry(calorieAmount: Int(100)))
    
    // Store updated values
    UserDefaults(suiteName: "group.com.calories.counter")?.setValue(newCal, forKey: "caloriesConsumed")
    
    if let encoded = try? JSONEncoder().encode(inputs) {
        UserDefaults(suiteName: "group.com.calories.counter")?.setValue(encoded, forKey: "calorieEntries")
    }
}

struct CalorieIntent: AppIntent {
    static var title: LocalizedStringResource = "Adds calories"
    static var description = IntentDescription("Adds a calorie amount to caloriesConsumed")
    
    
    // Implementation of the perform function
    func perform() async throws -> some IntentResult & ReturnsValue {
        // Add calories using the provided calorie input
        addCalories()
        
        // Return a success result
        return .result()
    }
}
