//
//  Wrappers.swift
//  SightTracking
//
//  Created by gradchenko on 17.02.20.
//  Copyright © 2020 Gleb Radchenko. All rights reserved.
//

import Foundation

typealias AnyFunction<T> = (T) -> Void

func throttle<T>(delay: TimeInterval, f: @escaping AnyFunction<T>) -> AnyFunction<T> {
    var timer: Timer?
    var timestamp: TimeInterval = 0
    
    return { value in
        let execute = {
            f(value)
            timestamp = Date.timeIntervalSinceReferenceDate
            timer?.invalidate()
            timer = nil
        }
        
        let sinceLastTimestamp = {
            return Date.timeIntervalSinceReferenceDate - timestamp
        }
        
        DispatchQueue.main.async {
            guard timer == nil else { return }
            let past = sinceLastTimestamp()
            
            if past < delay {
                timer = Timer.scheduledTimer(withTimeInterval: delay - past, repeats: false) { _ in execute() }
            } else {
                execute()
            }
        }
    }
}

func debounce(delay: TimeInterval, f: @escaping () -> Void) -> () -> Void {
    var timer: Timer?
    var timestamp: TimeInterval = 0
    
    return {
        timestamp = Date.timeIntervalSinceReferenceDate
        let sinceLastTimestamp = {
            return Date.timeIntervalSinceReferenceDate - timestamp
        }
        
        var delayedRef: (() -> Void)?
        let delayed = {
            let past = sinceLastTimestamp()
            
            if past < delay {
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: delay - past, repeats: false) { _ in delayedRef?() }
            } else {
                f()
                timer?.invalidate()
                timer = nil
            }
        }
        
        delayedRef = delayed
        
        DispatchQueue.main.async {
            guard timer == nil else { return }
            timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in delayed() }
        }
    }
}
