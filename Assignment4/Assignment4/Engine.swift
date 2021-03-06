//
//  Engine.swift
//  Assignment4
//
//  Created by Damon Emgenbroich on 4/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
/*
 Use the GridProtocol and Grid provided in the student template to create an Engine for the grid in the following manner.
 Create a Swift protocol called EngineDelegate protocol which declares the following:
	•	engineDidUpdate(withGrid:) taking a GridProtocol object as an argument
 Create a Swift protocol called EngineProtocol which declares the following:
	•	a var delegate of type EngineDelegate
	•	a var grid of type GridProtocol (gettable only)
	•	a var refreshRate of type Double defaulting to zero
	•	a var refreshTimer of type NSTimer
	•	two vars rows and cols with no defaults
	•	an initializer taking rows and cols
	•	a func step()-> an object of type GridProtocol
 Create a class called StandardEngine which  implements the EngineProtocol method, implementing the Game Of Life rules as in Assignment 3.  Create a singleton of StandardEngine in a lazy manner.  That creates a grid of size 10x10 by default.  Whenever the grid is created or changed, notify the 
     delegate with the delegate method and publish the grid object using an NSNotification.
 */
//

import Foundation


protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)

}

protocol EngineProtocol {
    var delegate: EngineDelegate? { get set }
    var grid: GridProtocol { get }
    var refreshRate: Double { get set }
    var refreshTimer: Timer? { get set }
    var rows: Int { get set }
    var cols: Int { get set }
    init(_ rows: Int, _ cols: Int)
    func step() -> GridProtocol
}

class StandardEngine: EngineProtocol, GridViewDataSource {
    public static let initSize = 10
    private static var instance : StandardEngine?
    var delegate: EngineDelegate?
    var grid: GridProtocol  {
        didSet {
            notifyGridChange()
        }
    }
    var refreshTimer: Timer?
    var refreshRate: Double = 0.0 {
        didSet{
                if refreshRate > 0.0 {
                    let timerInterval = refreshRate
                    if #available(iOS 10.0, *) {
                        refreshTimer = Timer.scheduledTimer(
                            withTimeInterval: timerInterval,
                            repeats: true
                        ) { (t: Timer) in
                            _ = self.step()
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
                else {
                    refreshTimer?.invalidate()
                    refreshTimer = nil
                }
        }
    }
    var rows: Int {
        didSet{
            //self.grid=Grid(self.rows,self.cols)
        }
    }
    var cols: Int{
        didSet{
            //self.grid=Grid(self.rows,self.cols)
        }
    }
    
    required init(_ rows: Int, _  cols: Int) {
        self.rows = rows
        self.cols = cols
        self.grid = Grid(rows, cols)
    }
    
    static func getInstance() -> StandardEngine {
        if(self.instance == nil){
            self.instance = StandardEngine(initSize, initSize)
        }
        return instance!
    }
    static func getNewInstance(rows: Int, cols: Int)-> StandardEngine {
        self.instance = nil
        self.instance = StandardEngine(rows, cols)
        return instance!
    }
    func step() -> GridProtocol {
        let nextGrid = grid.next()
        self.grid = nextGrid
        delegate?.engineDidUpdate(withGrid: self.grid)
        return grid
    }
    private func notifyGridChange() {
        delegate?.engineDidUpdate(withGrid: grid)
        let notificationCenter = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let notification = Notification(name: name, object: nil, userInfo: ["engine" : self])
        notificationCenter.post(notification)
    }
    public subscript (row: Int, col: Int) -> CellState {
       get { return self.grid[row,col] }
       set { self.grid[row,col] = newValue }
    }
}
