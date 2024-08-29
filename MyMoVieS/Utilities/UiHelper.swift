//
//  UiHelper.swift
//  MyMoVieS
//
//  Created by Abdulloh on 31/07/24.
//

import Foundation
import UIKit

struct UiHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
       let width = view.bounds.width
       let padding: CGFloat = 12
       let minimumItemSpacing: CGFloat = 10
       let availalbleWidth = width - (padding * 2) - (minimumItemSpacing * 2)
       let itemWidth = availalbleWidth / 3
       
       let flowLayout = UICollectionViewFlowLayout()
       
       flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
       flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
       
       return flowLayout
   }
    
    static func updateIDArray(with id: Int) {
        let defaults = UserDefaults.standard
        let key = "favorites"
        
        // Retrieve the current array of IDs from UserDefaults
        var ids = defaults.array(forKey: key) as? [Int] ?? []

        if let index = ids.firstIndex(of: id) {
            // ID found, so remove it from the array
            ids.remove(at: index)
            print("Removed ID \(id) from the array.")
        } else {
            // ID not found, so add it to the array
            ids.append(id)
            print("Added ID \(id) to the array.")
        }

        // Save the updated array back to UserDefaults
        defaults.set(ids, forKey: key)
    }
}
