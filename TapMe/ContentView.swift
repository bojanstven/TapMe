//
//  ContentView.swift
//  TapMe
//
//  Created by Bojan Mijic on 4.12.23..
//



import SwiftUI

struct ContentView: View {
    @StateObject private var tapViewModel = TapViewModel()

    
    var body: some View {
        TabView {
            // First Tab (TapView)
            TapView(tapViewModel: tapViewModel)
                .tabItem {
                    Image(systemName: "hand.tap.fill")
                    Text("Tap Me")
                }

            // Second Tab (AchievementsView)
            AchievementsView(tapViewModel: tapViewModel)
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Achievements")
                }

            // Third Tab (ViewStore)
            StoreView(tapViewModel: tapViewModel)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Store")
                }

            // Fourth Tab (ViewSettings)
            SettingsView(tapViewModel: tapViewModel)
            // Make sure to pass tapViewModel here
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
