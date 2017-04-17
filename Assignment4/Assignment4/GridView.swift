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
    @IBInspectable var numCol: Int = 10
    @IBInspectable var numRow: Int = 10
    @IBInspectable var livingColor : UIColor = UIColor.green
    @IBInspectable var emptyColor : UIColor = UIColor.white
    @IBInspectable var bornColor : UIColor = UIColor.cyan
    @IBInspectable var diedColor : UIColor = UIColor.black
    @IBInspectable var gridColor : UIColor = UIColor.darkGray
    @IBInspectable var gridWidth : CGFloat = 0.0
    // Updated since class
    var grid: GridViewDataSource?
    
    var xColor = UIColor.black
    var xProportion = CGFloat(1.0)
    var widthProportion = CGFloat(0.05)
    
    override func draw(_ rect: CGRect) {
        drawRec(rect)
    }
    
    func drawRec(_ rect: CGRect) {
        //let gridSize = CGFloat(self.numCol)
        let colSize = CGFloat(self.numCol)
        let rowSize = CGFloat(self.numRow)

        let cgSize = CGSize(
            width: rect.size.width / colSize,
            height: rect.size.height / rowSize
        )
        let base = rect.origin
        (0 ..< numCol).forEach { i in
            (0 ..< numRow).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(j) * cgSize.width),
                    y: base.y + (CGFloat(i) * cgSize.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: cgSize
                )
                let path = UIBezierPath(ovalIn: subRect)
                switch grid![(i, j)] {
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
        (0..<numCol).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/colSize * rect.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/colSize * rect.size.width, y: rect.size.height)
            )
        }
        (0..<numRow).forEach {
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/rowSize * rect.size.height ),
                end: CGPoint(x: rect.size.width, y: CGFloat($0)/rowSize * rect.size.height)
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
        let row = touchY / gridHeight * CGFloat(numCol)
        
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(numCol)
        
        return GridPosition(row: Int(row), col: Int(col))
    }
    
}

