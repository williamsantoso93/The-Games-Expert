//
//  The_GamesApp.swift
//  Shared
//
//  Created by William Santoso on 11/08/21.
//

import SwiftUI

@main
struct TheGamesApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                persistenceController.save()
            case .inactive:
                break
            case .active:
                break
            @unknown default:
                break
            }
        }
    }
}
