//
//  GridView.swift
//  Assignment4
//
//  Created by Damon Emgenbroich on 4/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//
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
    @IBInspectable var fillColor = UIColor.darkGray
    @IBInspectable var gridSize: Int = 10
    // Updated since class
    var grid: GridViewDataSource?
    
    var xColor = UIColor.black
    var xProportion = CGFloat(1.0)
    var widthProportion = CGFloat(0.05)
    
    override func draw(_ rect: CGRect) {
        drawOvals(rect)
        drawLines(rect)
    }
    
    func drawOvals(_ rect: CGRect) {
        let size = CGSize(
            width: rect.size.width / CGFloat(gridSize),
            height: rect.size.height / CGFloat(gridSize)
        )
        let base = rect.origin
        (0 ..< gridSize).forEach { i in
            (0 ..< gridSize).forEach { j in
                // Inset the oval 2 points from the left and top edges
                let ovalOrigin = CGPoint(
                    x: base.x + (CGFloat(j) * size.width) + 2.0,
                    y: base.y + (CGFloat(i) * size.height + 2.0)
                )
                // Make the oval draw 2 points short of the right and bottom edges
                let ovalSize = CGSize(
                    width: size.width - 4.0,
                    height: size.height - 4.0
                )
                let ovalRect = CGRect( origin: ovalOrigin, size: ovalSize )
                if let grid = grid, grid[i,j].isAlive {
                    drawOval(ovalRect)
                }
            }
        }
    }
    
    func drawOval(_ ovalRect: CGRect) {
        let path = UIBezierPath(ovalIn: ovalRect)
        fillColor.setFill()
        path.fill()
    }
    
    func drawLines(_ rect: CGRect) {
        //create the path
        (0 ..< (gridSize + 1)).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/CGFloat(gridSize) * rect.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/CGFloat(gridSize) * rect.size.width, y: rect.size.height)
            )
            
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(gridSize) * rect.size.height ),
                end: CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(gridSize) * rect.size.height)
            )
        }
    }
    
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        path.lineWidth = 2.0
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        path.move(to: start)
        
        //add a point to the path at the end of the stroke
        path.addLine(to: end)
        
        //draw the stroke
        UIColor.cyan.setStroke()
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
    var lastTouchedPosition: GridPosition?
    
    func process(touches: Set<UITouch>) -> GridPosition? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        
        //************* IMPORTANT ****************
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        //****************************************
        
        if grid != nil {
            grid![pos.row, pos.col] = grid![pos.row, pos.col].isAlive ? .empty : .alive
            setNeedsDisplay()
        }
        return pos
    }
    
    func convert(touch: UITouch) -> GridPosition {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(gridSize)
        
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(gridSize)
        
        return GridPosition(row: Int(row), col: Int(col))
    }
    
}

