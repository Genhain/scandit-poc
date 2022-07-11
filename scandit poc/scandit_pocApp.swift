//
//  scandit_pocApp.swift
//  scandit poc
//
//  Created by Ben Fowler on 5/7/2022.
//

import SwiftUI
import ScanditCaptureCore

@main
struct scandit_pocApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ScaningView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
