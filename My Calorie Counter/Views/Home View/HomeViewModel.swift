//
//  HomeViewModel.swift
//  My Calorie Counter
//
//  Created by Justin Fisher on 3/12/24.
//

import Foundation

final class HomeViewModel:ObservableObject{
    @Published var dataManager: DataManager
    @Published var caloriesConsumed: Double = 0.0
    @Published var caloriesInput: String = ""
    @Published var inputs: [CalorieEntry] = []
    
    init(dataManager:DataManager){
        self.dataManager = dataManager
        self.inputs = getAllObjects()
        self.caloriesConsumed = getCaloriesConsumed()
    }
    

    
    func addCalories() {
        guard let calories = Int(caloriesInput) else { return }
        caloriesConsumed += Double(calories)
        inputs.append(CalorieEntry(timestamp: Date(), calorieAmount: calories))
        
        UserDefaults.standard.set(caloriesConsumed
        ,forKey: "caloriesConsumed")
        
        
        saveAllObjects(allObjects:inputs)
        caloriesInput = ""
    }
    
    func getCaloriesConsumed()->Double{
        
        let caloriesConsumedStored = UserDefaults.standard.double(forKey: "caloriesConsumed")
        return caloriesConsumedStored
        
    }
    
    func getAllObjects() -> [CalorieEntry] {
        if let objectsData = UserDefaults.standard.data(forKey: "calorieEntries") {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode([CalorieEntry].self, from: objectsData) {
                if let firstEntry = objectsDecoded.first {
                    let currentDate = Date()
                    let calendar = Calendar.current
                    if calendar.isDate(firstEntry.timestamp, inSameDayAs: currentDate) {
                        var totalCalories: Double = 0.0
                        for calorieEntry in objectsDecoded {
                               totalCalories += Double(calorieEntry.calorieAmount)
                           }
                        UserDefaults.standard.set(totalCalories, forKey: "caloriesConsumed")
                        return objectsDecoded
                    } else {
                        // Clear the array in UserDefaults
                        UserDefaults.standard.removeObject(forKey: "calorieEntries")
                        UserDefaults.standard.set(0.0, forKey: "caloriesConsumed")
                        //TODO STORE PREVIOUS ENTERIES IN DB
                        
                        return []
                    }
                } else {
                    // If objectsDecoded is empty, return the default object
                    return []
                }
            }
        }
        return []
    }

     func saveAllObjects(allObjects: [CalorieEntry]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allObjects) {
            UserDefaults.standard.set(encoded, forKey: "calorieEntries")
        }
    }

    // Custom date formatter for displaying timestamps
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    
}
