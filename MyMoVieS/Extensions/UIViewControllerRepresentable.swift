//
//  UIViewControllerRepresentable.swift
//  MyMoVieS
//
//  Created by Abdulloh on 02/08/24.
//

import Foundation
import SwiftUI
import UIKit

struct LoadingView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LoadingViewController {
        return LoadingViewController()
    }
    
    func updateUIViewController(_ uiViewController: LoadingViewController, context: Context) {
        // No update needed
    }
}

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dissmissLoadingView()
    }
}
