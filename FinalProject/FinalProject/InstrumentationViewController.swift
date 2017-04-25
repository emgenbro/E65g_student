//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Damon Emgenbroich on 4/12/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
/*
 2) (20  points) Instrumentation Tab:
 In the instrumentation tab, create the following elements:
	•	A labeled UITextField for number of rows accompanied by a UIStepper in units of 10
	•	A labeled UITextField for number of columns accompanies by a UIStepper in units of 10
	•	A labeled UISlider for refresh rate allowing values from 0.1 to 10 Hz
	•	A labeled UISwitch which allows timed refresh to be turned on or off
 Make sure that layout looks good on all size classes with no warning messages.  All fonts and UI elements should be neatly  arranged and centered horizontally and vertically.

 
 */
//

import UIKit

class InstrumentationViewController : UIViewController {
    
    @IBOutlet weak var rowTextField: UITextField!
    @IBOutlet weak var colTextField: UITextField!
    @IBOutlet weak var timerOnOff: UISwitch!
    @IBOutlet weak var timerRefreshRate: UISlider!
    
    @IBAction func timerrefreshRateChanged(_ sender: UISlider) {
        if(timerOnOff.isOn){
            StandardEngine.getInstance().refreshRate = 0.0
            StandardEngine.getInstance().refreshRate = Double(timerRefreshRate.value)
        }
    }
    @IBAction func activateTimer(_ sender: UISwitch) {
        if(sender.isOn){
            StandardEngine.getInstance().refreshRate = Double(timerRefreshRate.value)
        }
        else {
            StandardEngine.getInstance().refreshRate = 0.0
        }
    }
    @IBAction func updateRows(_ sender: UITextField) {
        if(isInt(string: sender.text) && Int(sender.text!)! > 0 && Int(sender.text!)! <= 100){
            //let cols = StandardEngine.getInstance().cols
            _ = StandardEngine.getNewInstance(rows: Int(sender.text!)!, cols: Int(sender.text!)!)
        }
    }
    @IBAction func updateCols(_ sender: UITextField) {
        if(isInt(string: sender.text) && Int(sender.text!)! > 0 && Int(sender.text!)! <= 100){
            //let rows = StandardEngine.getInstance().rows
            _ = StandardEngine.getNewInstance(rows: Int(sender.text!)!, cols: Int(sender.text!)!)
        }
    }
    
    @IBAction func rowsStepper(_ sender: UIStepper) {
        if(sender.value > 0){
            //let cols = StandardEngine.getInstance().cols
            self.rowTextField.text = String(Int(sender.value))
            _ = StandardEngine.getNewInstance(rows: Int(sender.value), cols: Int(sender.value))
        }
    }
    
    @IBAction func colStepper(_ sender: UIStepper) {
        if(sender.value > 0){
            //let rows = StandardEngine.getInstance().rows
            self.colTextField.text = String(Int(sender.value))
            _ = StandardEngine.getNewInstance(rows: Int(sender.value), cols: Int(sender.value))
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.rowTextField.text = String(StandardEngine.initSize)
        self.colTextField.text = String(StandardEngine.initSize)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isInt(string: String!) -> Bool {
        return string != nil && Int(string) != nil
    }
    
}

