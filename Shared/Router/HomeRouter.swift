//
//  HomeRouter.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/19/21.
//

import SwiftUI

class HomeRouter {
    func makeDetailView(gameID: Int) -> some View {
        let detailUseCase = Injection.init().provideDetail(gamedID: gameID)
        let viewModel = DetailViewModel(gameID: gameID, detailUseCase: detailUseCase)
        return DetailScreen(viewModel: viewModel)
    }
    
    func makeFavoriteView() -> some View {
        let favoriteUseCase = Injection.init().provideFavorite()
        let viewModel = FavoriteViewModel(favoriteUseCase: favoriteUseCase)
        return FavoriteScreen(viewModel: viewModel)
    }
}
