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
    
    let homeViewModel = HomeViewModel(homeUseCase: Injection.init().provideHome())
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: homeViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(homeViewModel)
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
