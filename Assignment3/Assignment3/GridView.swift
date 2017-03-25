//
//  GridView.swift
//  Assignment3
//
//  Created by Damon Emgenbroich on 3/23/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
// 2. Create a subclass of UIVIew called GridView which has the following characteristics (5 points):
//    •	Is IBDesignable
//    •	Has the following IBInspectable Properties:
//      ◦	1 Integer: size (defaulting to 20)
//      ◦	4 UIColors: livingColor, emptyColor, bornColor, diedColor, gridColor (pick defaults)
//      ◦	CGFloat  gridWidth
//    •	Has the following normal characteristic:
//      ◦	a struct of type Grid drawn from the Grid.swift file which is provided in the Assignment3 
//          template and which is reinitialized to all .empty values with rows = size and cols = size every time that Inspectable size property changes
//
// 3. Instantiate a GridView in the Main.storyboard of Assignment3 and (5 points)
// •	Assign the following values for all of the above properties in the storyboard
// •	Use these values: size: 20, livingColor = some green, bornColor = same shade of green with .6 alpha,  
//      emptyColor = darkGray, diedColor = same shade of grey  with  .6 alpha, gridColor = black, gridWidth = 2.0
//

import Foundation
import UIKit

@IBDesignable class GridView: UIView {
    
    var grid = Grid(20, 20, cellInitializer: emptyInitializer)
    @IBInspectable var size : Int = 20 {
        didSet {
            grid = Grid(size, size, cellInitializer: emptyInitializer)
        }
    }
    @IBInspectable var livingColor : UIColor = UIColor.green
    @IBInspectable var emptyColor : UIColor = UIColor.white
    @IBInspectable var bornColor : UIColor = UIColor.cyan
    @IBInspectable var diedColor : UIColor = UIColor.black
    @IBInspectable var gridColor : UIColor = UIColor.darkGray
    @IBInspectable var gridWidth : CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        drawRec(rect)
        
    }
    func drawRec(_ rect: CGRect) {
        let gridSize = CGFloat(self.size)
        let cgSize = CGSize(
            width: rect.size.width / gridSize,
            height: rect.size.height / gridSize
        )
        let base = rect.origin
        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(j) * cgSize.width),
                    y: base.y + (CGFloat(i) * cgSize.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: cgSize
                )
                let path = UIBezierPath(ovalIn: subRect)
                // 4. implement a drawRect: method for GridView which: (40 points)
                //    •	draws the correct set of grid lines in the view using the techniques shown in class.
                //      Set the gridlines to have width as specified in the //gridWidth property and color as in gridColor
                //    •	draws a circle inside of every grid cell and fills the circle with the appropriate color
                //      for the grid cell drawn from the Grid struct discussed in Problem 2.  e.g. for grid cell (0,0)
                //      fetch the zero'th array from grid and then fetch the CellState value from the zero'th position
                //      of the array and color the circle using the color specified in IB. Repeat for the other values
                switch grid[(i, j)] {
                case .alive:
                    livingColor.setFill()
                case .empty:
                    emptyColor.setFill()
                case .born:
                    bornColor.setFill()
                case .died:
                    diedColor.setFill()
                }
                path.fill()
            }
        }
        
        //create the path
        (0..<size).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/gridSize * rect.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/gridSize * rect.size.width, y: rect.size.height)
            )
            
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/gridSize * rect.size.height ),
                end: CGPoint(x: rect.size.width, y: CGFloat($0)/gridSize * rect.size.height)
            )
        }
    }
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        path.lineWidth = gridWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        path.move(to: start)
        
        //add a point to the path at the end of the stroke
        path.addLine(to: end)
        
        //draw the stroke
        gridColor.setStroke()
        path.stroke()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    // Updated since class
    typealias Position = (row: Int, col: Int)
    var lastTouchedPosition: Position?
    
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            
            else { return pos }
        // 5. Using touch handling techniques shown in class  and  the toggle method of CellState, toggle the value of a
        //    touched cell from Empty to Living or from Living to Empty depending the current state of the cell and cause a redisplay to happen
        grid[(pos.row,pos.col)] = grid[(pos.row, pos.col)].toggle(value: grid[(pos.row, pos.col)])
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> Position {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(self.size)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(self.size)
        let position = (row: Int(row), col: Int(col))
        return position
    }
    
    func stepGrid(){
        grid = grid.next()
        setNeedsDisplay()
    }

    
}
