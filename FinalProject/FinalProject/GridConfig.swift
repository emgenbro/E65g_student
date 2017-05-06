//
//  GridConfig.swift
//  FinalProject
//
//  Created by Damon Emgenbroich on 4/30/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

class GridConfig {
    private static var instance : GridConfig?
    var theConfig = [String:Grid]()
    static let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
    var configJson : NSArray  {
        didSet{
            for gridConfigDictonary in configJson {
                let gridConfig = gridConfigDictonary as! NSDictionary
                let title = gridConfig["title"] as! String
                print(title)
                let contents = gridConfig["contents"] as! [[Int]]
                print(contents)
                self.theConfig[title] = Grid(10, 10)
                for cellPosition in contents {
                    let x = cellPosition[0] as Int
                    let y = cellPosition[1] as Int
                    self.theConfig[title]?[x,y]=CellState.born
                }
            }
            print(self.theConfig)
        }
    }
        
    
    
    static func getInstance() -> GridConfig {
        if(self.instance == nil){
            let fetcher = Fetcher()
            fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
                guard message == nil else {
                    print(message ?? "nil")
                    return
                }
                guard let json = json else {
                    print("no json")
                    return
                }
                self.instance = GridConfig()
                self.instance?.configJson = json as! NSArray
            }
        }
        while(instance == nil){}
        return instance!
    }
    
    private init(){
        configJson = []
    }
}
