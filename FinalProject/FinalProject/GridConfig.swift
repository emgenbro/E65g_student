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
                //print(contents)
                var size = 10
                for cellPosition in contents {
                    let x = cellPosition[0] as Int
                    let y = cellPosition[1] as Int
                    if(x > size){
                        size = x
                    }
                    if(y > size){
                        size = y
                    }
                }
                self.theConfig[title] = Grid(Int(roundUp(Double(size), toNearest:10)),Int(roundUp(Double(size), toNearest:10)))
                for cellPosition in contents {
                    let x = cellPosition[0] as Int
                    let y = cellPosition[1] as Int
                    self.theConfig[title]?[x,y]=CellState.alive
                }
            }
            //print(self.theConfig)
        }
    }
    
    func roundUp(_ value: Double, toNearest: Double) -> Double {
        return ceil(value / toNearest) * toNearest
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
    
    static func convertToString(grid: Grid) -> String {
        var representation : String = "empty," + String(grid.size.rows) + "," + String(grid.size.cols) + ":"
        
        (0 ..< grid.size.rows).forEach { i in
            (0 ..< grid.size.cols).forEach { j in
                
                if(grid[j,i] != CellState.empty){
                    representation += String(describing: grid[i,j])
                    representation += ","
                    representation += String(i)
                    representation += ","
                    representation += String(j)
                    representation += ":"
                }
            }
        }
        
        representation.remove(at: representation.index(before: representation.endIndex))
        print(representation)
        return representation
        
    }
    
    static func convertToGrid(_ gridString: String) -> Grid {
        var grid = Grid(10,10)
        let gridArray : [String] = gridString.components(separatedBy: ":")
        let gridSizeArray : [String] = gridArray[0].components(separatedBy: ",")
        let rows = Int(gridSizeArray[1])
        let cols = Int(gridSizeArray[2])
        if(rows! >= 10 && cols! >= 10)
        {
            grid = Grid(rows!,cols!)
        }
        for cell in gridArray {
            let cellArray : [String] = cell.components(separatedBy: ",")
            let cellState = cellArray[0]
            let cellRow = Int(cellArray[1])
            let cellCol = Int(cellArray[2])
            
            switch cellState
            {
                case "born":
                    grid[cellRow!,cellCol!]=CellState.born
                case "alive":
                    grid[cellRow!,cellCol!]=CellState.alive
                case "died":
                    grid[cellRow!,cellCol!]=CellState.died
                default:
                    grid[cellRow!,cellCol!]=CellState.empty
            }
        }
        return grid
    }
}
