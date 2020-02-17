//
//  SightInteractionHandler.swift
//  SightTracking
//
//  Created by gradchenko on 17.02.20.
//  Copyright © 2020 Gleb Radchenko. All rights reserved.
//

import Foundation
import UIKit

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
