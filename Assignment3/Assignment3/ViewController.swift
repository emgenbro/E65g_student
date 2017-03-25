//
//  ViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 6. Add a button labeled: "Step" which will iterate the grid when pressed using your modified version of Grid
    @IBOutlet weak var gofGrid: GridView!
    

    @IBAction func stepButtonAction(_ sender: Any) {
        gofGrid.stepGrid()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

