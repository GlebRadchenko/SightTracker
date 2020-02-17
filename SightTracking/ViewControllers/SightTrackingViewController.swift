//
//  SightTrackingViewController.swift
//  SightTracking
//
//  Created by Gleb Radchenko on 11/30/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class SightTrackingViewController: UIViewController {
    private lazy var sceneView: ARSCNView = ARSCNView()
    private let tracker = FaceTracker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSceneView()
        configureSceneView()

        tracker.onNextPoint = { [weak self] point in
            DispatchQueue.main.async {
                self?.handleNextSightPoint(point.adjustedToScreenBounds())
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func handleNextSightPoint(_ point: CGPoint) {
        
    }
    
    private func addSceneView() {
        view.addSubview(sceneView)
        view.sendSubviewToBack(sceneView)
        sceneView.alpha = 0.5
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneViewConstraints.activate()
    }
    
    private func configureSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        tracker.configure(with: sceneView)
    }
    
    // MARK: - Constraints
    
    private lazy var sceneViewConstraints = ConstraintContainer(
        leading: sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        trailing: sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        top: sceneView.topAnchor.constraint(equalTo: view.topAnchor),
        bottom: sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    )
}

extension SightTrackingViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        
        tracker.currentFaceNode = node
        tracker.currentFaceAnchor = anchor as? ARFaceAnchor
        
        node.name = "Face node"
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard node.geometry is ARSCNFaceGeometry, let anchor = anchor as? ARFaceAnchor else {
            return
        }
        
        tracker.updateNode(node, for: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        tracker.update(with: renderer)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
}
