//  MandelbrotRenderer.swift
//  MandelzoomSwift
//

import UIKit
import Foundation

class MandelbrotRenderer {
    private var ht: Int
    private var wth: Int
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
    private let topLeft: ComplexNumber
    private let bottomRight: ComplexNumber
    private let threshold = 200

    struct PixelData {
        var a: UInt8 = 255
        var r: UInt8 = 0
        var g: UInt8 = 0
        var b: UInt8 = 0

        init(red: UInt8, green: UInt8, blue: UInt) {
            self.r = UInt8(red)
            self.g = UInt8(green)
            self.b = UInt8(blue)
        }
    }

    init(height: Int, width: Int, topLeft: ComplexNumber, bottomRight: ComplexNumber) {
        //height and width of window
//        ht = height
        ht = 100
        wth = 100
//        wth = width
        //coordinates of graph area
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }

    func getCount(c: ComplexNumber) -> Int {
        var count = 0
        var z = ComplexNumber(x: 0, y: 0)
        while (count < threshold && z.size() < 2) {
            count = count + 1
            z = z.squaredPlus(c)
        }
        return count
    }

    // code to create image from http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
    func getImage() -> UIImage {
        let boxSize = 50
        var countArray = [ComplexNumber]()
        var pixels = [PixelData]()
        for stepY: Int in 0 ... Int(ht) {
            for stepX: Int in 0 ... Int(wth) {
                let c: ComplexNumber = ComplexNumber(x: Double(stepX), y: Double(stepY))
//                print("c is \(c)")
//                print("count is \(count)")
                countArray.append(c)
            }
        }
        let redPixel = PixelData(red: 255, green: 0, blue: 0)
        let greenPixel = PixelData(red: 0, green: 255, blue: 0)
        let bluePixel = PixelData(red: 0, green: 0, blue: 255)
        let goldPixel = PixelData(red: 255, green: 215, blue: 0)
        let whitePixel = PixelData(red: 255, green: 255, blue: 255)

        let tl = ComplexNumber(x: 0, y: 0)
        let tr = ComplexNumber(x: Double(wth), y: 0)
        let bl = ComplexNumber(x: 0, y: Double(ht))
        let br = ComplexNumber(x: Double(wth), y: Double(ht))

        // go through the countArray and generate the pixel map
        for point in countArray {
            // top left corner
            if point.isNear(tl, distance: boxSize) {
                pixels.append(redPixel)
                print("got a tl corner: \(point)")
            }
            // top right corner
            else if point.isNear(tr, distance: boxSize) {
                pixels.append(greenPixel)
                print("got a tr corner: \(point)")
            }
            // bottom left corner
            else if point.isNear(bl, distance: boxSize) {
                pixels.append(bluePixel)
                print("got a bl corner: \(point)")
            }
            // bottom right corner
            else if point.isNear(br, distance: boxSize) {
                pixels.append(goldPixel)
                print("got a br corner: \(point)")
            } else {
                pixels.append(whitePixel)
            }
        }

        let bitsPerComponent: UInt = 8
        let bitsPerPixel: UInt = 32
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

class ComplexNumber: CustomStringConvertible {
    var x: Double = 0
    var y: Double = 0
    var description: String {
        return "\(self.x),\(self.y)"
    }

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    func size() -> Double {
        return sqrt(x * x + y * y)
    }

    func squaredPlus(c: ComplexNumber) -> ComplexNumber {
        return self.square().add(c)
    }

    func square() -> ComplexNumber {
        let newX = self.x * self.x - (y * y)
        let newY = (self.x * self.y) * 2
        return ComplexNumber(x: newX, y: newY)
    }

    func add(that: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(x: self.x + that.x, y: self.y + that.y)
    }

    func isNear(that: ComplexNumber, distance: Int) -> Bool {
        let dX = that.x - self.x
        let dY = that.y - self.y
        if abs(dX) < Double(distance) && abs(dY) < Double(distance) {
            return true
        } else {
            return false
        }
    }
}