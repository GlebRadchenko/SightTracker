//
//  HeadNode.swift
//  SightTracking
//
//  Created by Gleb Radchenko on 11/30/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Head: SCNNode {
    static var rayLenght: CGFloat = 1
    
    var leftEye: SCNNode!
    var leftEyeEnd: SCNNode!
    
    var rightEye: SCNNode!
    var rightEyeEnd: SCNNode!
    
    var leftPupil: SCNNode!
    var rightPupil: SCNNode!
    
    override init() {
        super.init()
        leftEye = createEye()
        rightEye = createEye()
        
        addPupils()
        addRays()
        addEndSidePoints()
        addChildNode(leftEye)
        addChildNode(rightEye)
    }
    
    func createEye() -> SCNNode {
        let eye = SCNNode(geometry: SCNSphere(radius: 0.012))
        eye.geometry?.firstMaterial?.fillMode = .lines
        return eye
    }
    
    func addEndSidePoints() {
        leftEyeEnd = endSightNode()
        rightEyeEnd = endSightNode()
        
        leftEye.addChildNode(leftEyeEnd)
        rightEye.addChildNode(rightEyeEnd)
    }
    
    func endSightNode() -> SCNNode {
        let node = SCNNode(geometry: nil)
        node.position = SCNVector3(x: 0, y: 0, z: 5)
        return node
    }
    
    fileprivate func addPupils() {
        leftPupil = createPupil()
        rightPupil = createPupil()
        
        leftEye.addChildNode(leftPupil)
        rightEye.addChildNode(rightPupil)
    }
    
    fileprivate func addRays() {
        addRayIfNeeded(to: leftEye)
        addRayIfNeeded(to: rightEye)
    }
    
    fileprivate func createPupil() -> SCNNode {
        let pupil = SCNNode(geometry: SCNSphere(radius: 0.005))
        pupil.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        pupil.geometry?.firstMaterial?.fillMode = .lines
        pupil.position = SCNVector3(x: 0, y: 0, z: 0.012)
    
        return pupil
    }
    
    fileprivate func addRayIfNeeded(to eyeNode: SCNNode) {
        let ray = SCNNode(geometry: SCNCylinder(radius: 0.00125, height: Head.rayLenght))
        ray.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        ray.opacity = 0.5
        
        let rotate = SCNMatrix4MakeRotation(-.pi / 2, 1, 0, 0)
        let translate = SCNMatrix4MakeTranslation(0, 0, Float(Head.rayLenght) / 2)
        let transform = SCNMatrix4Mult(rotate, translate)
        
        ray.transform = transform
        
        eyeNode.addChildNode(ray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        simdTransform = anchor.transform
        leftEye.simdTransform = anchor.leftEyeTransform
        rightEye.simdTransform = anchor.rightEyeTransform
    }
}
