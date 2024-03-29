//
//  ViewController.swift
//  WatchME
//
//  Created by Sterling Mortensen on 7/10/19.
//  Copyright © 2019 Sterling Mortensen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    private let segueIdentifier  = "graphSegue"
    let numberToolbar: UIToolbar = UIToolbar()
    var errorTitle: String       = ""
    var errorMessage: String     = ""
    
    // MARK: - Override Functions
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        
        setupToolBar()
        
        setupGestureRecognizer()
        
        setupNotificationObservers()
        
        setupCircleLayers()
    
        setupTextFieldLayers()
        
        setupPercentageLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showProgress()
    }
    
    // MARK: - TextField Delegate Functions
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters   = "0123456789."
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet   = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    
    // MARK: - Helper Functions
    
    private func showProgress() {
        let percent          = LogController.shared.percentOfReachingGoal()
        percentageLabel.text = "\(Int(percent * 100))%"
        shapeLayer.strokeEnd = CGFloat(percent)
    }
    
    // MARK: - Setup View Functions
    
    private func setupGestureRecognizer() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftGesture(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func setupToolBar() {
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveWeightButtonTapped))
        ]
        
        numberToolbar.sizeToFit()
        weightTextField.inputAccessoryView = numberToolbar
        goalTextField.inputAccessoryView   = numberToolbar
    }
    
    private func setupTextFieldLayers() {
        weightTextField.delegate = self
        goalTextField.delegate   = self
        
        weightTextField.keyboardType = .decimalPad
        goalTextField.keyboardType   = .decimalPad
        
        logStackView.addArrangedSubview(weightTextField)
        logStackView.addArrangedSubview(goalTextField)
        logStackView.addArrangedSubview(currentWeightLabel)
        view.addSubview(logStackView)
        
        logStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
        logStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    // MARK: - Setup Circle Layers
    
    private func setupPercentageLabel() {
        self.percentStackView.addArrangedSubview(percentageLabel)
        self.percentStackView.addArrangedSubview(percentageSubLabel)
        view.addSubview(percentStackView)
        percentStackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        percentStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        animatePulsatingLayer()
        
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let circularPath  = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let layer         = CAShapeLayer()
        layer.path        = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth   = 20
        layer.fillColor   = fillColor.cgColor
        layer.lineCap     = CAShapeLayerLineCap.round
        layer.position    = view.center
        return layer
    }
    
    private func animatePulsatingLayer() {
        let animation            = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue        = 1.5
        animation.duration       = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses   = true
        animation.repeatCount    = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    // MARK: - Target Actions
    
    @objc func saveWeightButtonTapped() {
        guard let weightStr = self.weightTextField.text, !weightStr.isEmpty,
            let goalStr = self.goalTextField.text, !goalStr.isEmpty else {
                errorTitle   = "Missing Field"
                errorMessage = "Need to have a Goal entered and current weight."
                StaticFunctions.showErrorAlert(viewController: self, errorTitle: errorTitle, errorMessage: errorMessage)
                return
        }
        
        guard let weight = Double(weightStr), let goal = Double(goalStr) else {
            errorTitle   = "Invalid Input"
            errorMessage = "Only enter numbers and decimals"
            StaticFunctions.showErrorAlert(viewController: self, errorTitle: errorTitle, errorMessage: errorMessage)
            return
        }
        
        LogController.shared.saveLog(goal: goal, weight: weight)
        
        logStackView.isHidden = true
        
        self.weightTextField.resignFirstResponder()
        self.goalTextField.resignFirstResponder()
        self.weightTextField.text = ""
        
        showProgress()
    }
    
    @objc func cancelButtonTapped () {
        weightTextField.text = ""
        weightTextField.resignFirstResponder()
        goalTextField.resignFirstResponder()
        logStackView.isHidden = true
    }
    
    @objc func swipeLeftGesture(gesture: UIGestureRecognizer) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    @objc private func handleTap() {
        logStackView.isHidden = !logStackView.isHidden
        
        if logStackView.isHidden {
            weightTextField.resignFirstResponder()
            goalTextField.resignFirstResponder()
        } else {
            weightTextField.becomeFirstResponder()
            
            if let goal = LogController.shared.logs.last?.goal {
                self.goalTextField.text = "\(Int(goal))"
            }
            
            if let currentWeight = LogController.shared.logs.last?.weight {
                self.currentWeightLabel.text = " Current Weight : \(Int(currentWeight)) lbs"
            }
        }
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    // MARK: - UIComponents
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text          = "0%"
        label.textColor     = .white
        label.font          = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    let percentageSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text          = "Completed"
        label.textColor     = .white
        label.font          = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "weight:"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let currentWeightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
//        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let goalTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "goal weight:"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let logStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing      = 5
        stackView.isHidden     = true
        stackView.axis         = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    let percentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing      = 1
        stackView.axis         = .vertical
        stackView.distribution = .fill
        return stackView
    }()
}

