//
//  Log+Convenience.swift
//  WatchME
//
//  Created by Sterling Mortensen on 7/11/19.
//  Copyright © 2019 Sterling Mortensen. All rights reserved.
//

import Foundation
import CoreData

extension Log {
    convenience init(goal: Double, weight: Double, timestamp: Date = Date(), context: NSManagedObjectContext = Stack.context) {
        self.init(context: context)
        self.goal = goal
        self.weight = weight
        self.timestamp = timestamp
    }
}
