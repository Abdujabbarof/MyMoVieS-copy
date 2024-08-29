//
//  DetailedView.swift
//  MyMoVieS
//
//  Created by Abdulloh on 01/08/24.
//

import SwiftUI
import SafariServices
import WebKit

struct DetailedView: View {
    let movieId: Int
    @State private var movie: MovieDetail? = nil
    @State private var isExpanded: Bool = false
    @State private var showingSafari: Bool = false
    @State private var siteUrl: String? = nil
    @State private var trailers: [TrailerItem]? = nil
    @State private var similarMovies: [Film]? = nil
    @State private var savedIDs = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []

    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack {
                    // Background Image
                    AsyncImage(url: URL(string: movie?.posterUrl ?? "https://st.kp.yandex.net/images/no-poster.gif")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: screenWidth, height: screenWidth)
                            .clipped()
                    } placeholder: {
                    }.opacity(0.8)
                        .blur(radius: 3.0)
                    
                    Color.black
                        .opacity(0.4) // Adjust opacity to control darkness
                        .frame(width: screenWidth, height: screenWidth)
                    
                    // Foreground Content
                    VStack(alignment: .center) {
                        AsyncImage(url: URL(string: movie?.posterUrl ?? "https://st.kp.yandex.net/images/no-poster.gif")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth, height: screenWidth)
                                .cornerRadius(10)
                        } placeholder: {
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text((movie?.nameOriginal ?? movie?.nameEn ?? movie?.nameRu) ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    if let filmLength = movie?.filmLength {
                        HStack {
                            Text("Duration: ")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            + Text("\(filmLength) minutes")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    } else {
                        HStack {
                            Text("Duration: ")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            + Text("N/A")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if let rating = movie?.ratingImdb {
                        HStack {
                            Text("IMBD Rating: ")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            + Text("\(rating)")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    } else {
                        HStack {
                            Text("Rating: ")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            + Text("N/A")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if let countries = movie?.countries {
                        HStack {
                            Text("Countries:")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            ForEach(0..<countries.count, id: \.self) { index in
                                Text("\(String(describing: countries[index].country))")
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                        }.lineLimit(1)
                    }
                    
                    if let filmYear = movie?.year {
                        HStack {
                            Text("Released year: ")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                            + Text("\(filmYear)")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if let ganres = movie?.genres {
                        HStack(alignment: .bottom) {
                            Text("Genres:")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)

                            ForEach(0..<ganres.count, id: \.self) { index in
                                Text("\(String(describing: ganres[index].genre))" + (index != ganres.count - 1 ? "," : ""))
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                        }.lineLimit(1)
                    }
                    
                    if let description = movie?.description {
                        VStack(alignment: .leading) {
                            Text("\(description)")
                                .font(.body)
                                .foregroundColor(.gray)
                                .lineLimit(isExpanded ? nil : 3)
                                .padding(.top)

                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }) {
                                Text(isExpanded ? "Show Less" : "Show More")
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)
                                }
                            }
                            } else {
                                Text("No description available.")
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                    
                    NavigationLink {
                        WebView(url: movie?.webUrl?.replacingOccurrences(of: "kino", with: "ss") ?? "")
                    } label: {
                        Text("Watch now")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: screenWidth - (2 * (screenWidth * 0.05)), height: 60)
                            .background(.red)
                            .cornerRadius(10)
                    }.padding(.top)
                    
                    if let trailers = trailers, trailers.count > 0 {
                        Text("Trailers")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 10) { // Add spacing as needed
                                ForEach(0..<trailers.count, id: \.self) { index in
                                    if trailers[index].site?.lowercased() == "youtube" {
                                        VStack(alignment: .leading) {
                                            YouTubePlayer(embedUrl: convertToEmbedUrl(from: trailers[index].url ?? ""))
                                                .frame(width: screenWidth * 0.7, height: (screenWidth * 0.7) * 0.5625) // 16:9 aspect ratio
                                            
                                            Text(trailers[index].name ?? "")
                                                .font(.body)
                                                .fontWeight(.bold)
                                                .lineLimit(1)
                                                .frame(width: screenWidth * 0.7, alignment: .leading)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if let similarMovies = similarMovies, similarMovies.count > 0 {
                        Text("Similar movies")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 10) { // Add spacing as needed
                                ForEach(0..<similarMovies.count, id: \.self) { index in
                                    VStack (alignment: .leading, content: {
                                        AsyncImage(url: URL(string: similarMovies[index].posterUrl ?? "https://st.kp.yandex.net/images/no-poster.gif")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: (screenWidth / 3) - 10, height: ((screenWidth / 3) - 10) * 1.35)
                                                .cornerRadius(10)
                                        } placeholder: {
                                        }
                                        
                                        HStack(alignment: .top) {
                                            Text(similarMovies[index].nameEn ?? similarMovies[index].nameRu ?? "")
                                                .font(.system(size: 14))
                                                .fontWeight(.bold)
                                                .lineLimit(2)
                                                .frame(width: (screenWidth / 3) - 40, alignment: .leading)
                                            
                                            Button {
                                                UiHelper.updateIDArray(with: similarMovies[index].filmId)
                                                savedIDs = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
                                            } label: {
                                                Image(systemName: savedIDs.contains(similarMovies[index].filmId) ? "heart.fill" : "heart") // Replace "star.fill" with your desired SF Symbol
                                                        .font(.system(size: 20)) // Adjust the size as needed
                                                        .foregroundColor(savedIDs.contains(similarMovies[index].filmId) ? .red : .gray)
                                            }

                                        }.frame(width: (screenWidth / 3) - 10, alignment: .leading)
                                    }
                                    )
                                }
                            }
                        }
                    }

                }.padding(.leading, screenWidth * 0.05)
                    .padding(.trailing, screenWidth * 0.05)

            }
            .padding()
        }
        .navigationBarItems(trailing: Button(action: {
            UiHelper.updateIDArray(with: movieId)
            savedIDs = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        }) {
            Image(systemName: savedIDs.contains(movieId) ? "heart.fill" : "plus") // Replace "star.fill" with your desired SF Symbol
                    .font(.system(size: 20)) // Adjust the size as needed
                    .foregroundColor(savedIDs.contains(movieId) ? .red : .gray)
        })
        .onAppear {
            NetworkManager.shared.getMovie(for: movieId) { result in
                switch result {
                case .success(let movie):
                    self.movie = movie
                    
                    NetworkManager.shared.getSearchMovies(keyword: (movie.nameEn ?? movie.nameOriginal ?? movie.nameRu) ?? "") { result in
                        switch result {
                        case .success(let similar):
                            self.similarMovies = similar
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            NetworkManager.shared.getTrailers(for: movieId) { result in
                switch result {
                case .success(let trailer):
                    self.trailers = trailer.items
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

struct YouTubePlayer: UIViewRepresentable {
    let embedUrl: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        guard let url = URL(string: embedUrl) else { return webView }
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

func convertToEmbedUrl(from url: String) -> String {
    if url.contains("youtube.com") {
        return url.replacingOccurrences(of: "watch?v=", with: "embed/")
    } else if url.contains("youtu.be") {
        return url.replacingOccurrences(of: "youtu.be/", with: "youtube.com/embed/")
    }
    return url
}

struct WebView: UIViewRepresentable{
    
    var url:String
    
    func makeUIView(context: Context) -> some UIView {
        print(url)
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let webview = WKWebView()
        webview.load(URLRequest(url: url))
        return webview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
