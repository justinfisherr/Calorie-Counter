//
//  ContentView.swift
//  My Calorie Counter
//
//  Created by Justin Fisher on 3/10/24.
//

import SwiftUI

struct ContentView: View {
    private var firebaseInit = FirebaseInit()
    @StateObject private var dataManager = DataManager()
    var body: some View {
        HomeView(dataManager:dataManager)
    }
}

#Preview {
    ContentView()
}
