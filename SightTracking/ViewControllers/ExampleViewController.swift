//
//  ExampleViewController.swift
//  SightTracking
//
//  Created by gradchenko on 17.02.20.
//  Copyright © 2020 Gleb Radchenko. All rights reserved.
//

import UIKit

class ExampleViewController: SightTrackingViewController {
    @IBOutlet weak var statusLabel: UILabel!

    lazy var interactionHandler = SightInteractionHandler(view: view)
    lazy var pointer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.layer.cornerRadius = 16
        view.backgroundColor = .blue
        view.alpha = 0.5
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(pointer, at: 0)
    }
    
    override func handleNextSightPoint(_ point: CGPoint) {
        pointer.center = point
        interactionHandler.processSightPoint(point)
    }
    
    override func handleFaceExpressionEvent(_ event: FaceExpressionEvent) {
        interactionHandler.handleFaceExpressionEvent(event)
    }
    
    @IBAction func handleTap(_ sender: Button) {
        let text = sender.titleLabel?.text ?? "corner"
        statusLabel.text = text + " button tapped"
    }
}
