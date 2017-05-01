//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Damon Emgenbroich on 4/12/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//
//
// The statistics tab should remain as is, but should be reset whenever the user
// hits the reset button on the Simulation tab
//

import UIKit

class StatisticsViewController : UIViewController {
    
    @IBOutlet weak var emptyTextField: UITextField!
    @IBOutlet weak var bornTextField: UITextField!
    @IBOutlet weak var aliveTextField: UITextField!
    @IBOutlet weak var deadTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.updateStats(forGrid: StandardEngine.getInstance().grid)
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                self.updateStats(forGrid: StandardEngine.getInstance().grid)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateStats(forGrid: GridProtocol){
        
        var empty = 0
        var born = 0
        var alive = 0
        var dead = 0
        
        (0 ..< forGrid.size.rows).forEach { i in
            (0 ..< forGrid.size.cols).forEach { j in
                
                switch forGrid[j,i]
                {
                case CellState.empty:
                    empty += 1
                case CellState.born:
                    born += 1
                case CellState.alive:
                    alive += 1
                case CellState.died:
                    dead += 1
                }
            }
        }
        emptyTextField.text = String(empty)
        bornTextField.text = String(born)
        aliveTextField.text = String(alive)
        deadTextField.text = String(dead)
    }
}

