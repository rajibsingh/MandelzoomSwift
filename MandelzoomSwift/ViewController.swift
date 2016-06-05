//
//  ViewController.swift
//  MandelzoomSwift
//
//  Created by Rajib Singh on 4/16/16.
//  Copyright © 2016 Sepoy Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var drawableArea: DrawLineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var statuslabel: UILabel!

    @IBAction func buttonClick(sender: AnyObject) {
        statuslabel.text = String(mainImage.image?.size)
        let height = Int(mainImage.frame.size.height)
        let width = Int(mainImage.frame.size.width)
        let tl: ComplexNumber = ComplexNumber(x: -2.0, y: 1.5)
        let br: ComplexNumber = ComplexNumber(x: 0.5, y: -1.25)
        let renderer: MandelbrotRenderer = MandelbrotRenderer(height: height, width: width, topLeft: tl, bottomRight: br)
        let uiImage = renderer.getImage()
        mainImage.image = uiImage
    }
}

