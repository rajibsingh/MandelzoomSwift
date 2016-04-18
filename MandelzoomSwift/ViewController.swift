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
    
    
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct PixelData {
        var a:UInt8 = 255
        var r:UInt8 = 0
        var g:UInt8 = 0
        var b:UInt8 = 0
    }

    @IBOutlet weak var statuslabel: UILabel!
    
    @IBAction func buttonClick(sender: AnyObject) {
        statuslabel.text = String(mainImage.image?.size)
        let defaultPixel = PixelData()
        let height = UInt(mainImage.frame.size.height)
        let width = UInt(mainImage.frame.size.width)
        print("\(height) height, \(width) width")
        let pixels = [PixelData](count: Int(height) * Int(width), repeatedValue: defaultPixel)
        let uiImage = imageFromARGB32Bitmap(pixels, width: width, height: height)
        mainImage.image = uiImage
        drawableArea.changeColor()
    }
    
    func imageFromARGB32Bitmap(pixels:[PixelData], width:UInt, height:UInt)->UIImage {
        let bitsPerComponent:UInt = 8
        let bitsPerPixel:UInt = 32
        
        assert(pixels.count == Int(width * height))
        
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof(PixelData))
        )
        
        let cgim = CGImageCreate(
            Int(width),
            Int(height),
            Int(bitsPerComponent),
            Int(bitsPerPixel),
            Int(width) * sizeof(PixelData),
            rgbColorSpace,
            bitmapInfo,
            providerRef,
            nil,
            true,
            CGColorRenderingIntent.RenderingIntentDefault
        )
        return UIImage(CGImage: cgim!)
    }


}

