//
//  ViewModel.swift
//  My Calorie Counter
//
//  Created by Justin Fisher on 3/11/24.
//

import Foundation
class ViewModel: ObservableObject {
    struct CalorieEntry: Hashable, Encodable, Decodable {
        var timestamp: Date = Date()
        var calorieAmount: Int = 0
    }

    @Published var caloriesConsumed: Double = 0.0
    @Published var tdee: Double = 0.0
    @Published var inputs: [CalorieEntry] = []
    
    private var dataManager = DataManager()
    
    init() {
        loadInitialData()
    }
    
    func addCalories(_ calories: Int) {
        caloriesConsumed += Double(calories)
        inputs.append(CalorieEntry(timestamp: Date(), calorieAmount: calories))
        dataManager.saveAllObjects(inputs)
    }
    
    func loadInitialData() {
        caloriesConsumed = dataManager.loadCaloriesConsumed()
        tdee = dataManager.loadTDEE()
        inputs = dataManager.loadAllObjects()
    }
}
