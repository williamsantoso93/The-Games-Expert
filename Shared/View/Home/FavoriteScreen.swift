//
//  FavoriteScreen.swift
//  The Games (iOS)
//
//  Created by William Santoso on 21/08/21.
//

import SwiftUI
import SwiftUIX

struct FavoriteScreen: View {
    @ObservedObject var viewModel: FavoriteViewModel
    private let router = HomeRouter()
    
    var body: some View {
        Group {
            if !viewModel.filterGamesData.isEmpty {
                VStack(spacing: 0.0) {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filterGamesData.indices, id: \.self) { index in
                                NavigationLink(
                                    destination: router.makeDetailView(gameID: viewModel.filterGamesData[index].gameID),
                                    label: {
                                        CardView(game: viewModel.filterGamesData[index])
                                    })
                            }
                        }
                        .padding()
                    }
                }
            } else {
                Text("No Favorite Games")
            }
        }
        .navigationTitle("Favorite")
        .navigationSearchBar {
            SearchBar("Search Games", text: $viewModel.searchText)
            .onCancel {
                viewModel.searchText = ""
            }
            .searchBarStyle(.default)
        }
        .onAppear {
            viewModel.loadNewList()
        }
    }
}
