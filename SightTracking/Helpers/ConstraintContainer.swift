//
//  ConstraintContainer.swift
//  SightTracking
//
//  Created by gradchenko on 17.02.20.
//  Copyright © 2020 Gleb Radchenko. All rights reserved.
//

import UIKit

public class ConstraintContainer {
    public enum Key: Hashable {
        case leading, trailing, top, bottom, centerX, centerY, width, height, custom(String)
    }

    private var constraints: [Key: NSLayoutConstraint] = [:]

    public subscript(key: Key) -> NSLayoutConstraint? {
        get {
            return constraints[key]
        }
        set {
            constraints[key] = newValue
        }
    }

    public init(leading: NSLayoutConstraint? = nil, trailing: NSLayoutConstraint? = nil, top: NSLayoutConstraint? = nil, bottom: NSLayoutConstraint? = nil, centerX: NSLayoutConstraint? = nil, centerY: NSLayoutConstraint? = nil, width: NSLayoutConstraint? = nil, height: NSLayoutConstraint? = nil, other: [String: NSLayoutConstraint] = [:]) {
        self[.leading] = leading
        self[.trailing] = trailing
        self[.top] = top
        self[.bottom] = bottom
        self[.centerX] = centerX
        self[.centerY] = centerY
        self[.width] = width
        self[.height] = height

        other.forEach { key, constraint in
            self[.custom(key)] = constraint
        }
    }

    public func activate() {
        let constraintsToActivate = constraints.values.filter { !$0.isActive }
        guard !constraintsToActivate.isEmpty else { return }

        NSLayoutConstraint.activate(constraintsToActivate)
    }

    public func deactivate(shouldDeleteConstraints: Bool = false) {
        NSLayoutConstraint.deactivate(Array(constraints.values))

        if shouldDeleteConstraints {
            constraints.removeAll()
        }
    }

    public func deactivate(_ keys: [Key], shouldDeleteConstraints: Bool = false) {
        keys.forEach { key in
            let constraint = constraints[key]
            constraint?.isActive = false

            if shouldDeleteConstraints {
                constraints.removeValue(forKey: key)
            }
        }
    }
}
