//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Damon Emgenbroich on 4/30/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//


import UIKit

class GridEditorViewController: UIViewController, EngineDelegate  {
    
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
            editGridEngine.delegate = self
            editGridEngine.cols = GridConfig.getInstance().theConfig[configName]!.size.cols
            editGridEngine.rows = GridConfig.getInstance().theConfig[configName]!.size.rows
            editGridEngine.grid = GridConfig.getInstance().theConfig[configName]!
            editGrid.grid = editGridEngine
            editGrid.numCol = editGridEngine.cols
            editGrid.numRow = editGridEngine.rows
            self.editGrid.setNeedsDisplay()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.editGrid.setNeedsDisplay()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        if let newValue = gridConfigName.text,
            let saveClosure = saveClosure {
            saveClosure(newValue)
            StandardEngine.getInstance().grid = GridConfig.getInstance().theConfig[newValue]!
            StandardEngine.getInstance().rows = GridConfig.getInstance().theConfig[newValue]!.size.rows
            StandardEngine.getInstance().cols = GridConfig.getInstance().theConfig[newValue]!.size.cols
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    func engineDidUpdate(withGrid: GridProtocol) {
        self.editGrid.setNeedsDisplay()
    }
}
