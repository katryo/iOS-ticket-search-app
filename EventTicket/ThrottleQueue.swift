//
//  ThrottleQueue.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/23.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import Foundation

class ThrottleQueue {
    private let queue = DispatchQueue.main
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var prevStartDate: Date = Date.distantPast
    private let timeBeforeStart: TimeInterval = TimeInterval(exactly: 1)!
    
    //init() {}
    
    func throttle(lambda: @escaping () -> Void) {
        workItem.cancel()
        workItem = DispatchWorkItem() { [weak self] in
            self?.prevStartDate = Date()
            lambda()
        }
        let waitTime = prevStartDate.timeIntervalSinceNow > self.timeBeforeStart ? 0.0 : 1.0
        queue.asyncAfter(deadline: .now() + waitTime, execute: workItem)
    }
}
