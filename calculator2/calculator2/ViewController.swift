//
//  ViewController.swift
//  calculator2
//
//  Created by Annie Yin on 6/23/17.
//  Copyright © 2017 Annie Yin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display!.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInMiddleOfTyping = true
        }
    
    }
    
    @IBAction func clearDisplay(_ sender: UIButton) {
        display!.text = "0"
        userIsInMiddleOfTyping = false
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()

    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }

}

