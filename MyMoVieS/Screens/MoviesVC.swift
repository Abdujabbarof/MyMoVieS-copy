//
//  MoviesVC.swift
//  MyMoVieS
//
//  Created by Abdulloh on 30/07/24.
//

import UIKit
import SwiftUI

class MoviesVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var movieType: String = "TOP_100_POPULAR_FILMS"
    var movies: [Film] = []
    var filterMovies: [Film] = []
    
    var page: Int = 1
    var hasMoreMovies = true
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Film>!

    override func viewDidLoad() {
        super.viewDidLoad()
        congigViewController()
        configureCollectionView()
        getMovies(page: 1, movieType: movieType)
        configureDataSource()
        collectionView.delegate = self
        configureSearchController()
    }
    
    func congigViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UiHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
//        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search for a movies you want..."
        navigationItem.searchController = searchController
    }
    
    
    func getMovies(page: Int, movieType: String) {
        showLoadingView()
        NetworkManager.shared.getMovies(for: movieType, page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.dissmissLoadingView()
            switch result {
            case .success(let films):
                // Filter out duplicates
                let newMovies = films.filter { newFilm in
                    !self.movies.contains { $0.filmId == newFilm.filmId }
                }
                self.movies.append(contentsOf: newMovies)
                self.updateData(on: self.movies)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something bad happened :(", message: error.rawValue, buttonTitle: "Ok")
                print("Error: ", error.rawValue)
            }
        }
    }
    
    func getSaerchMovies(keyword: String) {
        NetworkManager.shared.getSearchMovies(keyword: keyword) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let films):
                self.filterMovies = films
                self.updateData(on: films)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Somthing bad happened ;(", message: error.rawValue, buttonTitle: "Ok")
                print("Error: ", error.rawValue)
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Film>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
            cell.set(film: movie)
            return cell
        })
    }
    
    func updateData(on movies: [Film]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Film>()
        snapShot.appendSections([.main])
        snapShot.appendItems(movies)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
}


extension MoviesVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreMovies else { return }
            page += 1
            getMovies(page: page, movieType: movieType)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
        let detailedView = DetailedView(movieId: selectedMovie.filmId)
        let hostingController = UIHostingController(rootView: detailedView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
}


extension MoviesVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            updateData(on: movies)
            return
        }
        
//        filterMovies = movies.filter { movie in
//            // Safely unwrap both `nameEn` and `nameRu` and check if either contains the filter term
//            let lowercasedFilter = filter.lowercased()
//            let nameEnMatches = movie.nameEn?.lowercased().contains(lowercasedFilter) ?? false
//            let nameRuMatches = movie.nameRu?.lowercased().contains(lowercasedFilter) ?? false
//            return nameEnMatches || nameRuMatches
//        }
        
//        updateData(on: filterMovies)
        
        getSaerchMovies(keyword: filter)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: movies)
    }
    
    
}
