//
//  LogController.swift
//  WatchME
//
//  Created by Sterling Mortensen on 7/11/19.
//  Copyright © 2019 Sterling Mortensen. All rights reserved.
//

import UIKit
import CoreData

class LogController {
    func saveLog(goal: Double = 0, weight: Double = 0) {
        let _ = Log(goal: goal, weight: weight)
        saveToPersistentStore()
        print("Saved Log")
    }
    
    func percentOfReachingGoal() -> Double {
        var percent: Double = 0
        let startWeight = self.logs.first?.weight ?? 0
        let currentWeight = self.logs.last?.weight ?? 0
        let goal = self.logs.last?.goal ?? 0
        
        if startWeight == 0 { return 0 }
        
        percent = ((startWeight - currentWeight) / (startWeight - goal))
        return percent
    }
    
    private func saveToPersistentStore() {
        do {
            try Stack.context.save()
        } catch let error {
            print("error saving persistently \(error.localizedDescription)")
        }
    }
    
    var logs: [Log] {
        let request: NSFetchRequest<Log> = Log.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        return (try? Stack.context.fetch(request)) ?? []
    }
    
    static let shared = LogController()
}
