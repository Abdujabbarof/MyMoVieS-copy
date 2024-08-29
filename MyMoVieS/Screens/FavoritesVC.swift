//
//  FavoritesVC.swift
//  MyMoVieS
//
//  Created by Abdulloh on 30/07/24.
//

import UIKit
import SwiftUI

class FavoritesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addFavoriteListView()
    }
    
    private func addFavoriteListView() {
        let favoriteListView = FvaroriteListView()
        let hostingController = UIHostingController(rootView: favoriteListView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Set up constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

