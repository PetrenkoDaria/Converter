//
//  ConverterApp.swift
//  Converter
//
//  Created by Дарья Петренко on 23.05.2023.
//

import SwiftUI

@main
struct ConverterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
