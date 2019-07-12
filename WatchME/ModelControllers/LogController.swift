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
    func saveLog(weight: Int) {
        let _ = Log(weight: weight)
        saveToPersistentStore()
        print("Saved Log")
    }
    
    func percentOfReachingGoal() -> Int32 {
        var percent: Int32 = 0
        let startWeight = self.logs.first?.weight ?? 0
        let currentWeight = self.logs.last?.weight ?? 0
        print(startWeight)
        print(currentWeight)
        percent = ((startWeight - currentWeight) / self.goal) * 100
        print(percent)
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
    let goal: Int32 = 190
}
