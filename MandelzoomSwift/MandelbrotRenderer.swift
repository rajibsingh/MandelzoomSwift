//  MandelbrotRenderer.swift
//  MandelzoomSwift
//
//  Created by Rajib Singh on 5/20/16.
//  Copyright © 2016 Sepoy Software. All rights reserved.

import UIKit
import Foundation

class MandelbrotRenderer {
    private var ht: Int
    private var wth: Int
    private var pixels: [PixelData] = [PixelData]()
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
    private let topLeft: ComplexNumber
    private let bottomRight: ComplexNumber
    private let iterations = 50
    private var countArray = [Int]()

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
        ht = height
        wth = width

        //coordinates of graph area
        self.topLeft = topLeft
        self.bottomRight = bottomRight
        //derive topRight and bottomLeft
        let topRight = ComplexNumber(x: bottomRight.x, y: topLeft.y)
        let bottomLeft = ComplexNumber(x: topRight.x, y: bottomRight.y)

        //debug info
        var points = [ComplexNumber(x: 0, y: 0)]

        //calculate offset
        let dX = (topRight.x - topLeft.x) / Double(width)
        let dY = (bottomRight.y - topRight.y) / Double(height)
        let offset = ComplexNumber(x: dX, y: dY)


        for stepX: Int in 0 ... Int(width) {
            for stepY: Int in 0 ... Int(height) {
                let valX = topRight.x + Double(stepX) * offset.x
                let valY = topRight.y + Double(stepY) * offset.y
                let c: ComplexNumber = ComplexNumber(x: valX, y: valY)
                var count: Int = getCount(c)
                countArray.append(count)
            }
        }

        let blackPixel = PixelData(red: 0, green: 0, blue: 0)
        let whitePixel = PixelData(red: 255, green: 255, blue: 255)


        for count in countArray {
            if (count >= 1) {
                pixels.append(blackPixel)
            } else {
                pixels.append(whitePixel)
            }
        }
    }

    func getCount(c: ComplexNumber) -> Int {
        var count = 0
        var z = ComplexNumber(x: 0, y: 0)
        while (count < iterations && z.size() < 2) {
            count++
            z = z.squaredPlus(c)
        }
        return count
    }

    func imageFromARGB32Bitmap() -> UIImage {
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

class ComplexNumber {
    var x: Double = 0
    var y: Double = 0

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
}