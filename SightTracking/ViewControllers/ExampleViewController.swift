//
//  ExampleViewController.swift
//  SightTracking
//
//  Created by gradchenko on 17.02.20.
//  Copyright © 2020 Gleb Radchenko. All rights reserved.
//

import UIKit

class ExampleViewController: SightTrackingViewController {
    lazy var interactionHandler = SightInteractionHandler(view: view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func handleNextSightPoint(_ point: CGPoint) {
        interactionHandler.processSightPoint(point)
    }
}
