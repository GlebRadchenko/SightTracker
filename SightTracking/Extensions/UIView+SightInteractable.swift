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

class SightInteractionHandler {
    private typealias InteractiveView = UIView & SightInteractable
    
    private weak var view: UIView!
    
    init(view: UIView) {
        self.view = view
    }
    
    private var lastFocusedView: InteractiveView?
    func processSightPoint(_ point: CGPoint) {
        guard let target = view.hitTest(point, with: nil) as? InteractiveView else {
            defocusIfNeeded()
            return
        }
        
        if target !== lastFocusedView {
            defocusIfNeeded()
        }
        
        let innerPoint = target.convert(point, from: view)
        target.handleSightFocus(at: innerPoint)
        lastFocusedView = target
    }
    
    private func defocusIfNeeded() {
        lastFocusedView?.handleSightDefocus()
        lastFocusedView = nil
    }
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
