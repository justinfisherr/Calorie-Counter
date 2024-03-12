//
//  ContentView.swift
//  My Calorie Counter
//
//  Created by Justin Fisher on 3/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var dataManager = DataManager()
    var body: some View {
        HomeView(dataManager:dataManager)
    }
}

#Preview {
    ContentView()
}
