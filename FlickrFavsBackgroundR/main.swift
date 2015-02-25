//
//  main.swift
//  FlickrFavsBackgroundR
//
//  Created by Silas Graffy on 06/02/15.
//  Copyright (c) 2015 Silas Graffy. All rights reserved.
//

import Foundation

if Process.arguments.count < 3 {
    println("Usage: FlickrFavsBackgroundR flickrApiKey flickrUserId [fetchCount]")
    println("       where flickrApiKey is a valid API Key for Flickr, ")
    println("             flickrUserId is a valid Flickr user id and")
    println("             fetchCount is an optional number between 1 and 500, setting how many images should be requested to find one of size 'k'.")
    println("")
    println("Example with fictional values: FlickrFavsBackgroundR 714d0642970fac78530fb593c46dfa34 66081508@N42 50")
    exit (1)
}

let flickrApiKey = Process.arguments[1]

let flickrUserId = Process.arguments[2]

var fetchCount = 100

if Process.arguments.count >= 4 {
    if let fetchParam = Process.arguments[3].toInt() {
        fetchCount = fetchParam
    } else {
        println("Warning: Unable to parse fetchCount parameter '\(Process.arguments[3])', using default value (\(fetchCount)). If you provide this parameter, please make sure to pass a numeric value between 1 and 500.")
    }
}

let libraryPath = "\(NSHomeDirectory())/Library/FlickrBackgroundR/"


let backgroundR = FlickrFavsBackgroudR(flickrApiKey: flickrApiKey, flickrUserId: flickrUserId, libraryPath: libraryPath, fetchCount: fetchCount)
backgroundR.go()