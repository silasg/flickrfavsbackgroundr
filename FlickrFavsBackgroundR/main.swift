//
//  main.swift
//  FlickrFavsBackgroundR
//
//  Created by Silas Graffy on 06/02/15.
//  Copyright (c) 2015 Silas Graffy. All rights reserved.
//

import Foundation

let flickrApiKey = "794d6625970fac78530fb593c46d7a34"

let flickrUserId = "66956608@N06"

let backgroundR = FlickrFavsBackgroudR(flickrApiKey: flickrApiKey, flickrUserId: flickrUserId)
backgroundR.go()