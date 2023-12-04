//
//  TapMeApp.swift
//  TapMe
//
//  Created by Bojan Mijic on 4.12.23..
//

import SwiftUI

@main
struct TapMeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
