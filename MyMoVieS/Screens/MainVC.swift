//
//  MainVC.swift
//  MyMoVieS
//
//  Created by Abdulloh on 30/07/24.
//

import UIKit
import SwiftUI

class MainVC: UIViewController {
    
    var movies: [Film] = []
    private var carouselView: CarouselView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        getMovies(page: 1, movieType: "TOP_100_POPULAR_FILMS")
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
                self.movies = newMovies
                
                // Update the carousel view with the new data
                DispatchQueue.main.async {
                    self.updateCarouselView()
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something bad happened :(", message: error.rawValue, buttonTitle: "Ok")
                print("Error: ", error.rawValue)
            }
        }
    }
    
    private func updateCarouselView() {
        if carouselView == nil {
            // Create a SwiftUI view if it does not exist
            carouselView = CarouselView(images: movies)
            let hostingController = UIHostingController(rootView: carouselView!)
            addChild(hostingController)
            view.addSubview(hostingController.view)
            hostingController.view.frame = view.bounds
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hostingController.didMove(toParent: self)
        } else {
            // Update the existing SwiftUI view
            carouselView?.images = movies
        }
    }
}
