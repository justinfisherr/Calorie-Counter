//
//  CalorieEntry.swift
//  My Calorie Counter
//
//  Created by Justin Fisher on 3/11/24.
//

import Foundation

struct CalorieEntry: Hashable, Codable {
    var timestamp: Date = Date()
    var calorieAmount: Int = 0
}
