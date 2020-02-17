//
//  CircullarBuffer.swift
//  SightTracking
//
//  Created by gradchenko on 17.02.20.
//  Copyright © 2020 Gleb Radchenko. All rights reserved.
//

import Foundation
import SceneKit

protocol CircularBufferElementType {
    static var zero: Self { get }
    static func + (_ lhs: Self, _ rhs: Self) -> Self
    static func / (_ lhs: Self, scalar: Float) -> Self
}

class CircularBuffer<T: CircularBufferElementType> {
    private let size: Int
    private let dequeueCount: Int
    private var array: [T] = []
    
    var average: T { array.reduce(.zero, +) / Float(array.count) }
    var isFull: Bool { size == array.count }
    
    init(size: Int = 50, dequeueCount: Int = 5) {
        self.size = size
        self.dequeueCount = dequeueCount
    }
    
    static func + (_ buffer: CircularBuffer, _ value: T) {
        if buffer.array.count > buffer.size {
            buffer.array.removeFirst(buffer.dequeueCount)
        }

        buffer.array.append(value)
    }
}

extension SCNVector3: CircularBufferElementType { }
