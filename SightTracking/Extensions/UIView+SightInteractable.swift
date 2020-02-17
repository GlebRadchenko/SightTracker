//
//  UIView+SightInteractable.swift
//  SightTracking
//
//  Created by gradchenko on 17.02.20.
//  Copyright © 2020 Gleb Radchenko. All rights reserved.
//

import Foundation
import UIKit

protocol SightInteractable: AnyObject {
    func handleSightFocus(at point: CGPoint)
    func handleSightDefocus()
}

class Button: UIButton, SightInteractable {
    func handleSightFocus(at point: CGPoint) {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.9
            self.transform = .init(scaleX: 1.1, y: 1.1)
        }
    }
    
    func handleSightDefocus() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
            self.transform = .identity
        }
    }
}

class Label: UILabel, SightInteractable {
    func handleSightFocus(at point: CGPoint) {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.9
            self.transform = .init(scaleX: 1.1, y: 1.1)
        }
    }
    
    func handleSightDefocus() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
            self.transform = .identity
        }
    }
}

// Can be done:
// - ScrollView
// - TableView
// - CollectionView
// - TextField
// - TextView
// - WebView
// etc
