//
//  FavoriteScreen.swift
//  The Games (iOS)
//
//  Created by William Santoso on 21/08/21.
//

import SwiftUI
import CoreData
import SwiftUIX

struct FavoriteScreen: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Favorite.timestamp, ascending: true)]) var results: FetchedResults<Favorite>
    @State var gamesData: [GameData] = []
    @State var searchText = ""
    var filterGamesData: [GameData] {
        if searchText.isEmpty {
            return gamesData
        }
        return gamesData.filter {
            $0.name.localizedStandardContains(searchText.lowercased())
        }
    }
    
    var body: some View {
        Group {
            if !filterGamesData.isEmpty {
                VStack(spacing: 0.0) {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filterGamesData.indices, id: \.self) { index in
                                NavigationLink(
                                    destination: DetailScreen(gameID: filterGamesData[index].gameID),
                                    label: {
                                        CardView(game: filterGamesData[index])
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
            SearchBar("Search Games", text: $searchText)
            .onCancel {
                searchText = ""
            }
            .searchBarStyle(.default)
        }
        .onAppear {
            var temp: [GameData] = []
            for result in results {
                var genres: [Item]?
                if let genresData = result.genres?.data(using: .utf8) {
                    genres = try? JSONDecoder().decode([Item].self, from: genresData)
                }
                let gameData: GameData = .init(gameID: Int(result.gameID), name: result.name ?? "-", released: result.released ?? "-", backgroundImage: result.backgroundImage, rating: result.rating, ratingTop: nil, parentPlatforms: nil, genres: genres)
                temp.append(gameData)
            }
            gamesData = temp
        }
    }
}

struct FavoriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteScreen()
    }
}
