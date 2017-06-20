//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Mac on 6/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    
    var brain = CalculatorBrain()
    var inTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let currentTextInDisplay = displayLabel.text!
        
        if !inTheMiddleOfTyping || currentTextInDisplay == "0"{
            displayLabel.text = digit
        } else {
            displayLabel.text = currentTextInDisplay + digit
        }
        inTheMiddleOfTyping = true
    }
    
    @IBAction func touchDot() {
        let currentTextInDisplay = displayLabel.text!
        if !currentTextInDisplay.contains(".") {
            displayLabel.text = currentTextInDisplay + "."
            inTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get { return Double(displayLabel.text!)! }
        set {
            let formatter = NumberFormatter()
            formatter.maximumSignificantDigits = 10
            displayLabel.text = formatter.string(from: newValue as NSNumber)
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if inTheMiddleOfTyping {
            brain.setOperand(displayValue)
            inTheMiddleOfTyping = false
        }
        
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
            if let result = brain.result.0 {
                displayValue = result
            }
        }
        
        historyLabel.text = brain.result.1
    }
    
    @IBAction func clearAll(_ sender: Any) {
        brain.clear();
        inTheMiddleOfTyping = false
        historyLabel.text = ""
        displayValue = 0
    }
}
