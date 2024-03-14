//
//  DataManager.swift
//  My Calorie Counter
//
//  Created by Justin Fisher on 3/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


class DataManager: ObservableObject{
    //This value needs to be shared through the views.
    @Published var tdee =  UserDefaults(suiteName:"group.com.calories.counter")?.double(forKey: "tdee")
    
    private var db = Firestore.firestore()
    
    init(){
        //removeStorage()
        //saveTestObject()
    }
    
    //IMPLEMENT
    func getLogs() {
          let logsCollection = db.collection("Logs")
          
          logsCollection.getDocuments { (querySnapshot, error) in
              if let error = error {
                  print("Error getting logs: \(error.localizedDescription)")
                  return
              }
              
              guard let documents = querySnapshot?.documents else {
                  print("No logs available")
                  return
              }
              
              for document in documents {
                  // Assuming each document contains a field named "logData" of type String
                  print(document.data())
              }
          }
      }
    
    func setLogs(calorieEntries: [CalorieEntry], caloriesConsumed: Double) {
        // Convert CalorieEntry objects to dictionaries
       
        let calorieEntryDicts = calorieEntries.map { entry -> [String: Any] in
            return [
                "timestamp": Timestamp(date: entry.timestamp),
                "calorieAmount": entry.calorieAmount
            ]
        }
        
        // Get today's date in mmddyy format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyy"
        let todayDate = dateFormatter.string(from: Date())
        
        // Create data dictionary for the new log document
        let logData: [String: Any] = [
            "date": todayDate,
            "calorieEntries": calorieEntryDicts,
            "caloriesConsumed": caloriesConsumed
        ]
        
        // Reference to the "Logs" collection
        let logsCollection = db.collection("Logs")
        
        // Add a new document to the "Logs" collection
        logsCollection.addDocument(data: logData) { error in
            if let error = error {
                print("Error adding log: \(error.localizedDescription)")
            } else {
                print("Log added successfully")
            }
        }
    }

    
    
    func changeTdee(inputTdee:Double){
        UserDefaults(suiteName:"group.com.calories.counter")?.set(inputTdee, forKey: "tdee")
        self.tdee = inputTdee
    }
    
    func removeStorage(){
        UserDefaults(suiteName:"group.com.calories.counter")?.removeObject(forKey: "caloriesConsumed")
        UserDefaults(suiteName:"group.com.calories.counter")?.removeObject(forKey: "calorieEntries")
        UserDefaults(suiteName:"group.com.calories.counter")?.removeObject(forKey: "tdee")
        UserDefaults(suiteName:"group.com.calories.counter")?.removeObject(forKey: "currentWeightLbs")
        UserDefaults(suiteName:"group.com.calories.counter")?.removeObject(forKey: "heightCm")
        UserDefaults(suiteName:"group.com.calories.counter")?.removeObject(forKey: "age")
        UserDefaults(suiteName:"group.com.calories.counter")?.removeObject(forKey: "activityLevel")
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
        
        let testEntryYesterday = CalorieEntry(timestamp: yesterday, calorieAmount: 1000)
        let testEntryYesterday2 = CalorieEntry(timestamp: yesterday, calorieAmount: 1900)
        let testEntryYesterday3 = CalorieEntry(timestamp: yesterday, calorieAmount: 1600)
        let testObjectsYesterday = [testEntryYesterday, testEntryYesterday2, testEntryYesterday3]
        
        let testEntry = CalorieEntry(timestamp: today, calorieAmount: 1500)
        let testEntry2 = CalorieEntry(timestamp: today, calorieAmount: 2000)
        let testEntry3 = CalorieEntry(timestamp: today, calorieAmount: 1800)
        let testObjects = [testEntry, testEntry2, testEntry3]

        if let encoded = try? encoder.encode(testObjectsYesterday) {
            UserDefaults(suiteName:"group.com.calories.counter")?.set(encoded, forKey: "calorieEntries")
        }
    }
    
}
