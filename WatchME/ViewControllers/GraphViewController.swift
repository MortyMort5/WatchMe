//
//  GraphViewController.swift
//  WatchME
//
//  Created by Sterling Mortensen on 7/16/19.
//  Copyright © 2019 Sterling Mortensen. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    @IBOutlet weak var chartView: ChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightGesture(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        self.view.backgroundColor = .backgroundColor
        chartView.contentMode = .scaleAspectFit

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ChartView.playAnimations()
    }
    
    @objc func swipeRightGesture(gesture: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}
