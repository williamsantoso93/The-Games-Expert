//
//  ContentView.swift
//  Shared
//
//  Created by William Santoso on 11/08/21.
//

import SwiftUI
import SwiftUIX

struct ContentView: View {
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        NavigationView {
            Group {
                if !viewModel.gamesData.isEmpty {
                    VStack(spacing: 0.0) {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.gamesData.indices, id: \.self) { index in
                                    NavigationLink(
                                        destination: DetailScreen(gameID: viewModel.gamesData[index].gameID),
                                        label: {
                                            CardView(game: viewModel.gamesData[index])
                                                .onAppear {
                                                    viewModel.loadMoreData(currentGamesData: viewModel.gamesData[index])
                                                }
                                        })
                                }
                            }
                            .padding()
                        }
                    }
                } else {
                    if viewModel.isLoading {
                        VStack(spacing: 16.0) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Text("Loading...")
                        }
                    } else {
                        Text(viewModel.message)
                    }
                }
            }
            .navigationTitle("The Games")
            .navigationSearchBar {
                SearchBar("Search Games", text: $viewModel.searchText, onCommit: {
                    viewModel.searchList()
                })
                .onCancel {
                    viewModel.clearSearch()
                }
                .searchBarStyle(.default)
            }
            .navigationBarItems(trailing:
                                    HStack(spacing: 16.0) {
                                        NavigationLink(
                                            destination: FavoriteScreen(),
                                            label: {
                                                Image(systemName: "heart.fill")
                                                    .font(.title)
                                            })
                                        NavigationLink(
                                            destination: ProfileScreen(),
                                            label: {
                                                Image(systemName: "person.circle.fill")
                                                    .font(.title)
                                            })
                                    }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
