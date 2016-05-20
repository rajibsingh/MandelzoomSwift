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
        let renderer:MandelbrotRenderer = MandelbrotRenderer(height:height, width:width)
        let uiImage = renderer.imageFromARGB32Bitmap()
        mainImage.image = uiImage
    }
}

class MandelbrotRenderer {
    
    private var ht:Int
    private var wth:Int
    private var pixels:[PixelData]
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
    
    struct PixelData {
        var a:UInt8 = 255
        var r:UInt8 = 0
        var g:UInt8 = 0
        var b:UInt8 = 0
    }
    
    init(height:Int, width:Int) {
        ht = height
        wth = width
        let pixelCount = Int(height * width)
        pixels = [PixelData]()
        for _ in 0 ... pixelCount {
            var localPixel = PixelData()
            localPixel.r = UInt8(arc4random_uniform(256))
            localPixel.g = UInt8(arc4random_uniform(256))
            localPixel.b = UInt8(arc4random_uniform(256))
            pixels.append(localPixel)
        }
    }
    
    func imageFromARGB32Bitmap()->UIImage {
        let bitsPerComponent:UInt = 8
        let bitsPerPixel:UInt = 32
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof(PixelData))
        )
        let cgim = CGImageCreate(
            Int(wth),
            Int(ht),
            Int(bitsPerComponent),
            Int(bitsPerPixel),
            Int(wth) * sizeof(PixelData),
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