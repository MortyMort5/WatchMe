//
//  ChartView.swift
//  WatchME
//
//  Created by Sterling Mortensen on 7/16/19.
//  Copyright © 2019 Sterling Mortensen. All rights reserved.
//

import Foundation
import Macaw

class ChartView: MacawView {
    
    static var logs                     = LogController.shared.logCountForSameDay()
    static let maxValue                 = 10
    static let lineWidth: Double        = 380
    
    static let weightLogs: [Double]     = logs.weightLogs
    static let dayLogs: [Double]        = logs.dayLogs
    static var animations: [Animation]  = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: ChartView.checkForData(), coder: aDecoder)
        backgroundColor = .clear
    }
    
    private static func checkForData() -> Group {
        logs = LogController.shared.logCountForSameDay()
        if logs.weightLogs.isEmpty {
            print("NO LOGS")
            return Group()
        }
        
        return createChart()
    }
    
    private static func createChart() -> Group {
        var items: [Node] = addYAxisItems() + addXAxisItems()
        items.append(createBars())
        return Group(contents: items, place: .identity)
    }
    
    private static func addYAxisItems() -> [Node] {
        let maxLines            = 5
        let lineInterval        = Int(maxValue/maxLines)
        let yAxisHeight: Double = 200
        let lineSpacing: Double = 40
        var newNodes: [Node]    = []
        
        for i in 1...maxLines {
            let y          = yAxisHeight - (Double(i) * lineSpacing)
            let valueLine  = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.white.with(a: 0.10))
            let valueText  = Text(text: "\(i * lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill = Color.white
            
            newNodes.append(valueLine)
            newNodes.append(valueText)
        }
        
        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.white.with(a: 0.25))
        newNodes.append(yAxis)
        
        return newNodes
    }
    
    private static func addXAxisItems() -> [Node] {
        let chartBaseY: Double = 200
        var newNodes: [Node]   = []
        
        for i in 1...weightLogs.count {
            let x          = (Double(i) * 50)
            let valueText  = Text(text: "\(Int(weightLogs[i - 1]))", align: .max, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15))
            valueText.fill = Color.white
            newNodes.append(valueText)
        }
        
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.white.with(a: 0.25))
        newNodes.append(xAxis)
        
        return newNodes
    }
    
    private static func createBars() -> Group {
        let fill  = LinearGradient(degree: 90, from: Color(val: 0xff4704), to: Color(val: 0xff4704).with(a: 0.33))
        let items = dayLogs.map { _ in Group() }
        
        animations = items.enumerated().map { (i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1) { t in
                let height = dayLogs[i] * t
//                print("Adjusted Data Height - \(height) ----- Normal - \(dayLogs[i]) ------ i - \(i) ----- t - \(t)")
                let rect = Rect(x: Double(i) * 50 + 25, y: 200 - height, w: 30, h: height)
                return [rect.fill(with: fill)]
            }
        }
        
        return items.group()
    }
    
    static func playAnimations() {
        animations.combine().play()
    }
    
    
    private static func createDummyData() -> [SwiftNews] {
        let one   = SwiftNews(showNumber: "55", viewCount: 2834)
        let two   = SwiftNews(showNumber: "23", viewCount: 3354)
        let three = SwiftNews(showNumber: "74", viewCount: 1254)
        let four  = SwiftNews(showNumber: "23", viewCount: 3325)
        let five  = SwiftNews(showNumber: "87", viewCount: 3123)
        
        return [one, two, three, four, five]
    }
}

struct SwiftNews {
    let showNumber: String
    let viewCount: Double
}
