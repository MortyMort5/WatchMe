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
        
        let logs = LogController.shared.logCountForSameDay()
        if logs.weightLogs.isEmpty {
            self.showNoLogAlert()
        } else {
            ChartView.playAnimations()
        } 
    }
    
    func showNoLogAlert() {
        let alertController = UIAlertController(title: "No Logs", message: "You need to log a weight first.", preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAlertAction)
        self.present(alertController, animated: true)
    }
    
    @objc func swipeRightGesture(gesture: UIGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
}
