//
//  FaceTracker.swift
//  SightTracking
//
//  Created by Gleb Radchenko on 11/30/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class FaceTracker {
    weak var view: ARSCNView!
    
    var onNextPoint: ((CGPoint) -> Void)?
    
    var pointOfView: SCNNode? {
        return view?.pointOfView
    }
    
    var isReady: Bool {
        return currentFaceAnchor != nil
    }
    
    var currentFaceAnchor: ARFaceAnchor?
    var currentFaceNode: SCNNode?
    
    var faceGeometry: ARSCNFaceGeometry? {
        return currentFaceNode?.geometry as? ARSCNFaceGeometry
    }
    
    lazy var screenNode: SCNNode = {
        let screenGeometry = SCNPlane(width: 0.2, height: 0.2)
        let node = SCNNode(geometry: screenGeometry)
        
        node.geometry?.firstMaterial?.isDoubleSided = true
        node.name = "Phone plane"
        node.position = SCNVector3(0, 0, -0.03)
        node.opacity = 0
        
        return node
    }()
    
    lazy var deviceNode: SCNNode = {
        let node = SCNNode(geometry: nil)
        node.addChildNode(screenNode)
        node.name = "Device node"
        return node
    }()
    
    lazy var focusNode: SCNNode = {
       let node = SCNNode(geometry: SCNSphere(radius: 0.001))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        return node
    }()
    
    var head = Head()
    var gazePoints: [CGPoint] = []
    
    func configure(with view: ARSCNView) {
        self.view = view
        
        view.scene.rootNode.addChildNode(deviceNode)
        view.scene.rootNode.addChildNode(head)
        view.scene.rootNode.addChildNode(focusNode)
    }
    
    func updateNode(_ node: SCNNode, for anchor: ARFaceAnchor) {
        self.currentFaceNode = node
        self.currentFaceAnchor = anchor
        
        guard let geometry = faceGeometry else {
            return
        }
        
        geometry.update(from: anchor.geometry)
        head.update(withFaceAnchor: anchor)
    }
    
    func update(with rendered: SCNSceneRenderer) {
        guard isReady else { return }
        guard let pointOfView = pointOfView else { return }
        deviceNode.transform = pointOfView.transform
        
        guard let lEyeHitTest = hitTest(node: deviceNode, gaze: leftEyeGaze()).first else { return }
        guard let rEyeHitTest = hitTest(node: deviceNode, gaze: rightEyeGaze()).first else { return }
        
        process(l: lEyeHitTest, r: rEyeHitTest)
    }
    
    private let buffer = CircularBuffer<SCNVector3>()
    
    fileprivate func process(l: SCNHitTestResult, r: SCNHitTestResult) {
        let middle = (l.worldCoordinates + r.worldCoordinates) / 2
        focusNode.position = middle
        
        buffer + view.projectPoint(middle)
        
        if buffer.isFull {
            onNextPoint?(buffer.average.cgPoint())
        }
    }
}

extension FaceTracker {
    typealias Gaze = (start: SCNVector3, end: SCNVector3)
    
    fileprivate func hitTest(node: SCNNode, gaze: Gaze) -> [SCNHitTestResult] {
        let start = view.scene.rootNode.convertPosition(gaze.start, to: node)
        let end = view.scene.rootNode.convertPosition(gaze.end, to: node)
        
        return node.hitTestWithSegment(from: start, to: end, options: hitTestOptions())
    }
    
    fileprivate func hitTestOptions() -> [String: Any]? {
        return [SCNHitTestOption.backFaceCulling.rawValue: false,
                SCNHitTestOption.searchMode.rawValue: SCNHitTestSearchMode.all.rawValue,
                SCNHitTestOption.ignoreChildNodes.rawValue: false,
                SCNHitTestOption.ignoreHiddenNodes.rawValue: false]
    }
    
    fileprivate func leftEyeGaze() -> Gaze {
        if let anchor = currentFaceAnchor, let node = currentFaceNode {
            let start = node.convertPosition(SCNVector3(m: anchor.leftEyeTransform), to: nil)
            let end = node.convertPosition(SCNVector3(anchor.lookAtPoint), to: nil)
            
            return (start, end)
        }
        
        let start = head.leftEye.worldPosition
        let end = head.leftEyeEnd.worldPosition
        
        return (start, end)
    }
    
    fileprivate func rightEyeGaze() -> Gaze {
        if let anchor = currentFaceAnchor, let node = currentFaceNode {
            let start = node.convertPosition(SCNVector3(m: anchor.rightEyeTransform), to: nil)
            let end = node.convertPosition(SCNVector3(anchor.lookAtPoint), to: nil)
            
            return (start, end)
        }
        
        let start = head.rightEye.worldPosition
        let end = head.rightEyeEnd.worldPosition
        
        return (start, end)
    }
}

extension CGPoint {
    func adjustedToScreenBounds() -> CGPoint {
        let bounds = UIScreen.main.bounds
        let newX = max(min(x, bounds.width), 0)
        let newY = max(min(y, bounds.height), 0)
        
        return CGPoint(x: newX, y: newY)
    }
}
