
Mandelzoom
==========

![Current Rendering](http://i.imgur.com/26BFIIv.png)

refer to the classic [article](https://www.scientificamerican.com/media/inline/blog/File/Dewdney_Mandelbrot.pdf) by AK Dewdney for the Mathematical Recreations column of the Scientific American. 

learning iOS development and Swift to put together a viewer for the mandelbrot set.


# completed
* initial view

# upcoming
* panning
* zooming
* smoothing? Gaussian blur?
* performance?


# performance
6/7
> /Users/raj/repos/MandelzoomSwift/MandelzoomSwiftTests/MandelzoomSwiftTests.swift:38: Test Case '-[MandelzoomSwiftTests.MandelzoomSwiftTests testPerformanceExample]' measured [Time, seconds] average: 2.332, relative standard deviation: 1.332%, values: [2.315850, 2.359547, 2.336854, 2.301020, 2.278341, 2.332330, 2.306003, 2.334244, 2.370551, 2.382907], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100

* removed extraneous print statements
>/Users/raj/repos/MandelzoomSwift/MandelzoomSwiftTests/MandelzoomSwiftTests.swift:38: Test Case '-[MandelzoomSwiftTests.MandelzoomSwiftTests testPerformanceExample]' measured [Time, seconds] average: 2.335, relative standard deviation: 1.030%, values: [2.383088, 2.325033, 2.347197, 2.325099, 2.332956, 2.288096, 2.360615, 2.342019, 2.324729, 2.324523], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
