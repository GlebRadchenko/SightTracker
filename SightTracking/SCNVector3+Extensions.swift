//
//  SCNVector3+Extensions.swift
//  SightTracking
//
//  Created by Gleb Radchenko on 11/30/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//


import Foundation
import SceneKit
import CoreLocation

extension SCNVector3: Hashable {
    public var hashValue: Int { return "\(x),\(y),\(z)".hashValue }
}

extension SCNVector3: Equatable {
    static var zero: SCNVector3 {
        return SCNVector3Zero
    }
    
    var length: Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    var normalized: SCNVector3 {
        return self / length
    }
    
    func distance(to vector: SCNVector3) -> Float {
        return (self - vector).length
    }
    
    init(m: matrix_float4x4) {
        self.init(m.columns.3.x, m.columns.3.y, m.columns.3.z)
    }
}

public func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

public func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
}

public func *= (vector: inout  SCNVector3, scalar: Float) {
    vector = vector * scalar
}

public func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
}

public func /= (vector: inout  SCNVector3, scalar: Float) {
    vector = vector / scalar
}

public func + (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    return SCNVector3(l.x + r.x, l.y + r.y, l.z + r.z)
}

public func += (l: inout SCNVector3, r: SCNVector3) {
    l = l + r
}

public func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    return SCNVector3(l.x - r.x, l.y - r.y, l.z - r.z)
}

public func -= (l: inout  SCNVector3, r: SCNVector3) {
    l = l - r
}

public func * (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    return SCNVector3(l.x * r.x, l.y * r.y, l.z * r.z)
}

public func *= (l: inout  SCNVector3, r: SCNVector3) {
    l = l * r
}

public func / (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    return SCNVector3(l.x / r.x, l.y / r.y, l.z / r.z)
}

public func /= (l: inout  SCNVector3, r: SCNVector3) {
    l = l / r
}

public func min(_ l: SCNVector3, _ r: SCNVector3) -> SCNVector3 {
    let ld3 = double3(l)
    let rd3 = double3(r)
    
    return SCNVector3(min(ld3, rd3))
}

public func max(_ l: SCNVector3, _ r: SCNVector3) -> SCNVector3 {
    let ld3 = double3(l)
    let rd3 = double3(r)
    
    return SCNVector3(max(ld3, rd3))
}


