//
//  DrawLineView.swift
//  MandelzoomSwift
//
//  Created by Rajib Singh on 4/17/16.
//  Copyright © 2016 Sepoy Software. All rights reserved.
//

import UIKit

class DrawLineView: UIView {
    
    var defaultColor: CGColor = UIColor.redColor().CGColor
    
    convenience init() {
        self.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, defaultColor)
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, 200, 200)
        CGContextStrokePath(context)
        CGContextSetStrokeColorWithColor(context, defaultColor)
        let rectangle = CGRectMake(50,50,frame.size.width-100,frame.size.height-100)
        CGContextAddRect(context,rectangle)
        CGContextStrokePath(context)
    }
    
    func changeColor() {
        defaultColor = UIColor.purpleColor().CGColor
        setNeedsDisplay()
    }
}
