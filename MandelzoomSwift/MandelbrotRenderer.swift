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
    private let threshold = 10
    private let iterations = 200
    private let offset: ComplexNumber

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
        ht = height
        wth = width
        self.topLeft = topLeft
        self.bottomRight = bottomRight
        let dX = (bottomRight.x - topLeft.x) / Double(wth)
        let dY = (bottomRight.y - topLeft.y) / Double(ht)
        offset = ComplexNumber(x: dX, y: dY)
    }

    func getCount(c: ComplexNumber) -> Int {
        var count = 0
        var z = ComplexNumber(x: 0, y: 0)
        while (count < iterations && z.size() < 2) {
            count = count + 1
            z = z.squaredPlus(c)
        }
        return count
    }

    // code to create image from http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
    func getImage() -> UIImage {
        let boxSize = 50
        var countArray = [Int]()
        var pixels = [PixelData]()
        for stepY: Int in 0 ... Int(ht) - 1 {
            for stepX: Int in 0 ... Int(wth) - 1 {
                let x = topLeft.x + (Double(stepX) * offset.x)
                let y = topLeft.y + (Double(stepY) * offset.y)
                let c: ComplexNumber = ComplexNumber(x: x, y: y)
                var count = getCount(c)
                countArray.append(count)
                print("c is \(c) and count is \(count)")
            }
        }
        let redPixel = PixelData(red: 255, green: 0, blue: 0)
        let greenPixel = PixelData(red: 0, green: 255, blue: 0)
        let bluePixel = PixelData(red: 0, green: 0, blue: 255)
        let goldPixel = PixelData(red: 255, green: 215, blue: 0)
        let whitePixel = PixelData(red: 255, green: 255, blue: 255)
        let blackPixel = PixelData(red: 0, green: 0, blue: 0)
        let grayPixel = PixelData(red: 125, green: 125, blue: 125)

        let tl = ComplexNumber(x: 0, y: 0)
        let tr = ComplexNumber(x: Double(wth), y: 0)
        let bl = ComplexNumber(x: 0, y: Double(ht))
        let br = ComplexNumber(x: Double(wth), y: Double(ht))

        // go through the countArray and generate the pixel map
        for count in countArray {
            if count > threshold / 2 && count < threshold  {
                pixels.append(grayPixel)
            } else if count > threshold {
                pixels.append(blackPixel)
            }
            else {
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
        print("pixels size is \(pixels.count)");
        print("countArray size is \(countArray.count)")
        return UIImage(CGImage: cgim!)
    }
}

class ComplexNumber: CustomStringConvertible {
    var x: Double = 0
    var y: Double = 0
    var description: String {
        return "(\(self.x), \(self.y)i)"
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
        if sqrt(dX * dX + dY * dY) <  Double(distance) {
            return true
        } else {
            return false
        }
    }

    func inBox(that: ComplexNumber, distance: Int) -> Bool {
        let dX = that.x - self.x
        let dY = that.y - self.y
        if abs(dX) < Double(distance) && abs(dY) < Double(distance) {
            return true
        } else {
            return false
        }
    }
}