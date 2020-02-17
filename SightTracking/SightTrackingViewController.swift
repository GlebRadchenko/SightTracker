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
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var debugLabel: UILabel!
    
    private let tracker = FaceTracker()
    
    lazy var pointer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.layer.cornerRadius = 16
        view.backgroundColor = .blue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        sceneView.addSubview(pointer)
        
        tracker.configure(with: sceneView)
        tracker.debugLabel = debugLabel
        tracker.pointer = pointer
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
