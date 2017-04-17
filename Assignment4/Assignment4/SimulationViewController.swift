//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Damon Emgenbroich on 4/12/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//
// 4)  (25 points) Simulation Tab:
// Should have:
//	•	a properly constrained GridView as in Assignment 3.
//	•	a properly constrained UIButton which steps the delegate
// SimulationViewController should:
//	•	implement the EngineDelegate protocol
//	•	in viewDidLoad: set itself as the delegate of the StandardEngine singleton
//	•	invoke the step() method of the singleton when the step button is pressed
//

import UIKit

class SimulationViewController : UIViewController, EngineDelegate, GridViewDataSource {
    
    
    @IBOutlet weak var gridView: GridView!
    @IBAction func stepButton(_ sender: UIButton) {
        _ = StandardEngine.getInstance().step()
        gridView.setNeedsDisplay()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StandardEngine.getInstance().delegate = self
        gridView.grid = self
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
    public subscript (row: Int, col: Int) -> CellState {
        get { return StandardEngine.getInstance().grid[row,col] }
        set { StandardEngine.getInstance().grid[row,col] = newValue }
    }
}
