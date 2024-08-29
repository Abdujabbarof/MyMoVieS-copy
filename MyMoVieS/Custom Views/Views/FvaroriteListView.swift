//
//  FvaroriteListView.swift
//  MyMoVieS
//
//  Created by Abdulloh on 02/08/24.
//

import Foundation
import SwiftUI

struct FvaroriteListView: View {
    private let screenWidth = UIScreen.main.bounds.width
    @State private var favoriteMovies: [MovieDetail] = []
    @State private var isLoading = true

    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
            } else if favoriteMovies.isEmpty {
                Text("No Favorites Available")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .frame(width: screenWidth, height: UIScreen.main.bounds.height, alignment: .center)
            } else {
                List {
                    ForEach(favoriteMovies, id: \.kinopoiskId) { movie in
                        NavigationLink(destination: DetailedView(movieId: movie.kinopoiskId)) {
                        HStack(alignment: .top, spacing: 10) { // Adjust spacing as needed
                            AsyncImage(url: URL(string: movie.posterUrl ?? "https://st.kp.yandex.net/images/no-poster.gif")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (screenWidth / 5) - 10, height: ((screenWidth / 5) - 10) * 1.35)
                                    .cornerRadius(10)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: (screenWidth / 5) - 10, height: ((screenWidth / 5) - 10) * 1.35)
                            }
                            
                            VStack(alignment: .leading, content: {
                                Text(movie.nameOriginal ?? movie.nameEn ?? movie.nameRu ?? "No Title")
                                    .padding(.top, 5)
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                
                                Text(movie.description ?? "No description available")
                                    .font(.system(size: 14))
                                    .lineLimit(2)
                            }).frame(width: screenWidth - (screenWidth / 5) - (screenWidth / 5))
                        }
                        .frame(width: screenWidth)
                    }
                    }
                    .onDelete(perform: deleteFavorite)
                }
                .refreshable {
                    fetchFavoriteMovies()
                }
            }
        }
        .onAppear {
            fetchFavoriteMovies()
        }
    }
    
    private func deleteFavorite(at offsets: IndexSet) {
        offsets.forEach { index in
            let movie = favoriteMovies[index]
            UiHelper.updateIDArray(with: movie.kinopoiskId)
        }
        fetchFavoriteMovies() // Refresh the list after deletion
    }
    
    private func fetchFavoriteMovies() {
        isLoading = true
        let group = DispatchGroup()
        var fetchedMovies: [MovieDetail] = []
        
        for id in UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? [] {
            group.enter()
            NetworkManager.shared.getMovie(for: id) { result in
                switch result {
                case .success(let film):
                    fetchedMovies.append(film)
                case .failure(let error):
                    print("Error fetching movie details: \(error.rawValue)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.favoriteMovies = fetchedMovies
            self.isLoading = false
        }
    }
}
