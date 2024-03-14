//
//  HomeViewModel.swift
//  My Calorie Counter
//
//  Created by Justin Fisher on 3/12/24.
//

import Foundation
import WidgetKit
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
        
        UserDefaults(suiteName:"group.com.calories.counter")?.set(caloriesConsumed
        ,forKey: "caloriesConsumed")
        
        WidgetCenter.shared.reloadTimelines(ofKind: "Calorie_Counter_Widget")
        
        saveAllObjects(allObjects:inputs)
        caloriesInput = ""
    }
    
    func getCaloriesConsumed()->Double{
        
        let caloriesConsumedStored = UserDefaults(suiteName:"group.com.calories.counter")?.double(forKey: "caloriesConsumed") ?? 0.0
        return caloriesConsumedStored
        
    }
    
    func getAllObjects() -> [CalorieEntry] {
        if let objectsData = UserDefaults(suiteName:"group.com.calories.counter")?.data(forKey: "calorieEntries") {
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
                        UserDefaults(suiteName:"group.com.calories.counter")?.set(totalCalories, forKey: "caloriesConsumed")
                        // Return objectsDecoded before calling setLogs
                        return objectsDecoded
                    } else {
                        // Collect data for setLogs
                        let totalCalories = objectsDecoded.reduce(0, { $0 + Double($1.calorieAmount) })
                        dataManager.setLogs(calorieEntries: objectsDecoded, caloriesConsumed: totalCalories)
                        UserDefaults(suiteName:"group.com.calories.counter")?.removeObject(forKey: "calorieEntries")
                        UserDefaults(suiteName:"group.com.calories.counter")?.set(0.0, forKey: "caloriesConsumed")
                    }
                }
            }
        }
        return []
    }

     func saveAllObjects(allObjects: [CalorieEntry]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allObjects) {
            UserDefaults(suiteName:"group.com.calories.counter")?.set(encoded, forKey: "calorieEntries")
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
