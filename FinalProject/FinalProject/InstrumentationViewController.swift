//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Damon Emgenbroich on 4/12/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//
//Instrumentation Tab
//
//As before: the Instrumentation tab must allow the user to input the following characteristics:
//
//rows,
//columns,
//refreshRate (or interval),
//start/stop timed update of the grid
//Additionally the Instrumentation tab should now have a table view Labeled "Configurations" 
//whose number of rows and whose contents are determined by parsing a JSON file read from this link:
//
//https://dl.dropboxusercontent.com/u/7544475/S65g.json (Links to an external site.)Links to an external site..
//
//An example of the JSON file is:
//
//S65g-1.json
//
//Each element in top level array will contain a title for the row and contents for a preconfigured collection of cells to be turned on in the grid.
//
//When the user clicks on a row in the file, a segue should occur to a GridEditor controller which displays the content of the file in a GridView with the 
//file content shown in the view.  The user should be allowed to edit the cells and retain the representation in the tableview going forward.  Clicking a 
//"Save" button on the GridEditor should cause the user to return to the main instrumentation page after publishing the Grid object from the GridEditor via 
//NotificationCenter.  There should be a Cancel button instead a back button.
//
//The Configuration table view should be located towards the top of the Instrumentation page and there should be a plus button in the navigation bar which 
//allows the user to add rows to the table.
//

import UIKit

class InstrumentationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sectionHeaders = [
        "Configurations"
    ]
    
    @IBOutlet weak var rowTextField: UITextField!
    @IBOutlet weak var colTextField: UITextField!
    @IBOutlet weak var timerOnOff: UISwitch!
    @IBOutlet weak var timerRefreshRate: UISlider!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        self.tableView.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(GridConfig.getInstance().theConfig.keys).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = Array(GridConfig.getInstance().theConfig.keys)[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            var newData = data
//            newData.remove(at: indexPath.row)
//            data[indexPath.section] = newData
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.reloadData()
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if let indexPath = indexPath {
            let keyValue = Array(GridConfig.getInstance().theConfig.keys)[indexPath.row]
            if let vc = segue.destination as? GridEditorViewController {
                vc.configName = keyValue
                vc.saveClosure = { newValue in
                    StandardEngine.getInstance().grid = vc.editGridEngine.grid
                    self.tableView.reloadData()
                }
            }
        }
    }

    
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

