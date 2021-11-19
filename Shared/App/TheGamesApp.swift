//
//  The_GamesApp.swift
//  Shared
//
//  Created by William Santoso on 11/08/21.
//

import SwiftUI

@main
struct TheGamesApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    let homeViewModel = HomeViewModel(homeUseCase: Injection.init().provideHome())
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: homeViewModel)
                .environmentObject(homeViewModel)
        }
    }
}
