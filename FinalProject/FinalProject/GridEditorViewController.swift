//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Damon Emgenbroich on 4/30/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//


import UIKit

class GridEditorViewController: UIViewController {
    
    //var fruitValue: String?
    var configName: String?
    var saveClosure: ((String) -> Void)?
    var editGridEngine = StandardEngine(10, 10)
    
    @IBOutlet weak var gridConfigName: UITextField!
    @IBOutlet weak var fruitValueTextField: UITextField!
    @IBOutlet weak var editGrid: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        if let configName = configName {
            gridConfigName.text = configName
            editGridEngine.grid = GridConfig.getInstance().theConfig[configName]!
            editGrid.grid = editGridEngine
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        if let newValue = gridConfigName.text,
            let saveClosure = saveClosure {
            saveClosure(newValue)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
