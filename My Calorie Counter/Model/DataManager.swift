//
//  DataManager.swift
//  My Calorie Counter
//
//  Created by Justin Fisher on 3/11/24.
//

import Foundation


class DataManager: ObservableObject{
    //This value needs to be shared through the views.
    @Published var tdee =  UserDefaults.standard.double(forKey: "tdee")
    
    init(){
        //removeStorage()
       //saveTestObject()
    }
    
    func changeTdee(inputTdee:Double){
        UserDefaults.standard.set(inputTdee, forKey: "tdee")
        self.tdee = inputTdee
    }
    
    func removeStorage(){
        UserDefaults.standard.removeObject(forKey: "caloriesConsumed")
       UserDefaults.standard.removeObject(forKey: "calorieEntries")
        UserDefaults.standard.removeObject(forKey: "tdee")
        UserDefaults.standard.removeObject(forKey: "currentWeightLbs")
        UserDefaults.standard.removeObject(forKey: "heightCm")
        UserDefaults.standard.removeObject(forKey: "age")
        UserDefaults.standard.removeObject(forKey: "activityLevel")
    }
    
    
    /*
     struct CalorieEntry: Hashable, Codable {
         var timestamp: Date = Date()
         var calorieAmount: Int = 0
     }

     */
    func saveTestObject() {
        let encoder = JSONEncoder()
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        let testEntryYesterday = CalorieEntry(timestamp: yesterday, calorieAmount: 1700)
        let testEntryYesterday2 = CalorieEntry(timestamp: yesterday, calorieAmount: 1900)
        let testEntryYesterday3 = CalorieEntry(timestamp: yesterday, calorieAmount: 1600)
        let testObjectsYesterday = [testEntryYesterday, testEntryYesterday2, testEntryYesterday3]
        
        let testEntry = CalorieEntry(timestamp: today, calorieAmount: 1500)
        let testEntry2 = CalorieEntry(timestamp: today, calorieAmount: 2000)
        let testEntry3 = CalorieEntry(timestamp: today, calorieAmount: 1800)
        let testObjects = [testEntry, testEntry2, testEntry3]

        if let encoded = try? encoder.encode(testObjects) {
            UserDefaults.standard.set(encoded, forKey: "calorieEntries")
        }
    }
    
}
