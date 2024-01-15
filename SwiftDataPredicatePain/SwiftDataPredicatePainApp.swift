//
//  SwiftDataPredicatePainApp.swift
//  SwiftDataPredicatePain
//
//  Created by Jon Duenas on 1/15/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataPredicatePainApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
            CoffeeBag.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
