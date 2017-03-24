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
//      ◦	a struct of type Grid drawn from the Grid.swift file which is provided in the Assignment3 template and which is reinitialized to all .empty values with rows = size and cols = size every time that Inspectable size property changes
//

import Foundation
import UIKit

@IBDesignable class GridView: UIView {
    
    var grid = Grid(20, 20, cellInitializer: gliderInitializer)
    @IBInspectable var size = 20 {
        didSet {
            grid = Grid(size, size, cellInitializer: gliderInitializer)
        }
    }
    @IBInspectable var livingColor = UIColor.green
    @IBInspectable var emptyColor = UIColor.white
    @IBInspectable var bornColor = UIColor.cyan
    @IBInspectable var diedColor = UIColor.black
    @IBInspectable var gridColor = UIColor.darkGray
    @IBInspectable var gridWidth : CGFloat = 0.0
    
}
