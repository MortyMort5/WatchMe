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
    convenience init(weight: Int, timestamp: Date = Date(), context: NSManagedObjectContext = Stack.context) {
        self.init(context: context)
        self.weight = Int32(weight)
        self.timestamp = timestamp
    }
}
