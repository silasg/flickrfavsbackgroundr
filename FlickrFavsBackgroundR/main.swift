//
//  main.swift
//  FlickrFavsBackgroundR
//
//  Created by Silas Graffy on 06/02/15.
//  Copyright (c) 2015 Silas Graffy. All rights reserved.
//

import Foundation

if Process.arguments.count != 4 {
    println("Usage: FlickrFavsBackgroundR flickrApiKey flickrUserId")
    println("Example using fictional values: FlickrFavsBackgroundR 714d0642970fac78530fb593c46dfa34 66081508@N42")
    exit (1)
}

let flickrApiKey = Process.arguments[1]

let flickrUserId = Process.arguments[2]

let libraryPath = "\(NSHomeDirectory())/Library/FlickrBackgroundR/"


let backgroundR = FlickrFavsBackgroudR(flickrApiKey: flickrApiKey, flickrUserId: flickrUserId, libraryPath: libraryPath)
backgroundR.go()