//
//  GoalsViewModel.swift
//  My Calorie Counter
//
//  Created by Justin Fisher on 3/12/24.
//

import Foundation
final class GoalsViewModel :ObservableObject{
    @Published var dataManager: DataManager
    @Published var currentWeightLbs: String = ""
    @Published var heightCm: String = ""
    @Published var age: String = ""
    @Published var activityLevel: String = ""
    @Published var tdee: Double = 0.0
    @Published var isSaveEnabled: Bool = false
    @Published var anyFieldEdited: Bool = false

    
    let activityLevels = ["Default","Sedentary", "Light", "Moderate", "Active", "Very Active", "Super Active"]
    init(dataManager:DataManager){
        self.dataManager = dataManager
    }
    
    
    
    func updateSaveButtonState() {
        let fieldsFilled = currentWeightLbs != "" && heightCm != "" && age != "" && activityLevel != "Default"
        let valuesChanged = currentWeightLbs != UserDefaults.standard.string(forKey: "currentWeightLbs") ||
        heightCm != UserDefaults.standard.string(forKey: "heightCm") ||
        age != UserDefaults.standard.string(forKey: "age") ||
        activityLevel != UserDefaults.standard.string(forKey: "activityLevel")
        
        isSaveEnabled = fieldsFilled && (valuesChanged)
        calculateTDEE() // Calculate TDEE whenever input fields change
    }
    
    func saveGoals() {
        UserDefaults.standard.set(currentWeightLbs, forKey: "currentWeightLbs")
        UserDefaults.standard.set(heightCm, forKey: "heightCm")
        UserDefaults.standard.set(age, forKey: "age")
        UserDefaults.standard.set(activityLevel, forKey: "activityLevel")
        dataManager.changeTdee(inputTdee: tdee)
        isSaveEnabled  = false
        
    }
    
    func loadUserData() {
        currentWeightLbs = UserDefaults.standard.string(forKey: "currentWeightLbs") ?? ""
        heightCm = UserDefaults.standard.string(forKey: "heightCm") ?? ""
        age = UserDefaults.standard.string(forKey: "age") ?? ""
        activityLevel = UserDefaults.standard.string(forKey: "activityLevel") ?? ""
        tdee = UserDefaults.standard.double(forKey: "tdee")
        
    }
    
    func calculateTDEE() {
        guard let weightLbs = Double(currentWeightLbs),
              let heightCm = Double(heightCm),
              let age = Double(age),
              let activityIndex = activityLevels.firstIndex(of: activityLevel) else {
            return
        }
        
        // Convert weight from pounds to kilograms
        let weightKg = weightLbs * 0.45359237
        
        // Calculate BMR using the Mifflin-St Jeor equation
        let bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + 5
        
        // Calculate TDEE based on BMR and activity level
        let activityFactors = [0, 1.2, 1.375, 1.55, 1.725, 1.9]
        let tdee = bmr * activityFactors[activityIndex]
        
        self.tdee = tdee
    }
    
}
