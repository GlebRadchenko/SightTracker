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
    private var timer: Timer?

    func handleSightFocus(at point: CGPoint) {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.9
            self.transform = .init(scaleX: 1.1, y: 1.1)
        }
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
                self?.sendActions(for: .touchUpInside)
            }
        }
    }
    
    func handleSightDefocus() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
            self.transform = .identity
        }
        
        timer?.invalidate()
        timer = nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if super.point(inside: point, with: event) {
            return true
        }

        let expandedArea = bounds.insetBy(dx: -20, dy: -20)
        return expandedArea.contains(point)
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
