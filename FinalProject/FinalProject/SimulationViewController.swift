//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Damon Emgenbroich on 4/12/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//
/*
 
 The Simulation tab should be equipped with two new buttons:
 
 Save, which should prompt the user for a name and take the current representation and associate it with that name in the tableview on the instrumentation page and
 
 Reset, which should completely clear the contents of the grid view
 
 */
//

import UIKit

class SimulationViewController : UIViewController, EngineDelegate {
    
    @IBOutlet weak var gridView: GridView!
    @IBAction func stepButton(_ sender: UIButton) {
        _ = StandardEngine.getInstance().step()
        //gridView.setNeedsDisplay()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadThisView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadThisView()
        //gridView.setNeedsDisplay()
    }
    
    private func loadThisView(){
        StandardEngine.getInstance().delegate = self
        gridView.grid = StandardEngine.getInstance()
        gridView.numCol = StandardEngine.getInstance().cols
        gridView.numRow = StandardEngine.getInstance().rows
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
            self.gridView.setNeedsDisplay()
        }
        //gridView.setNeedsDisplay()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
}
