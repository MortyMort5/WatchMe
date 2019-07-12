//
//  User+Convenience.swift
//  WatchME
//
//  Created by Sterling Mortensen on 7/11/19.
//  Copyright © 2019 Sterling Mortensen. All rights reserved.
//

import Foundation
import CoreData

extension User {
    convenience init(name: String, goal: Int, startDate: Date, context: NSManagedObjectContext = Stack.context) {
        self.init(context: context)
        self.name = name
        self.goal = Int32(goal)
        self.startDate = startDate
    }
}
