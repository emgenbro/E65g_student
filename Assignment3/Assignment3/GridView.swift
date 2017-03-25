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
                //if grid[i][j] {
                //    let path = UIBezierPath(ovalIn: subRect)
                //    gridColor.setFill()
                //    path.fill()
                //}
                //if arc4random_uniform(2) == 1 {
                    let path = UIBezierPath(ovalIn: subRect)
                    bornColor.setFill()
                    path.fill()
                //}
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

    
}
