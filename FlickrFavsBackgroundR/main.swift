//
//  main.swift
//  FlickrFavsBackgroundR
//
//  Created by Silas Graffy on 06/02/15.
//  Copyright (c) 2015 Silas Graffy. All rights reserved.
//

import Foundation
import Cocoa
import Appkit


let flickrApiKey = "794d6625970fac78530fb593c46d7a34"

let flickrUserId = "66956608@N06"

let flickrFetchCount = 100

let flickrRestUrl = "https://api.flickr.com/services/rest/?method=flickr.favorites.getPublicList&api_key=\(flickrApiKey)&user_id=\(flickrUserId)&per_page=\(flickrFetchCount)&extras=url_k"

let flickrFavsUrl = NSURL(string: flickrRestUrl)

let flickrFavsDelegate = FlickrFavsParserDelegate()
var xmlParser = NSXMLParser(contentsOfURL: flickrFavsUrl)!
xmlParser.delegate = flickrFavsDelegate
println("Getting and parsing Favorite Photos of Flickr User '\(flickrUserId)' with Size 'k' (2048 px min)...")
xmlParser.parse()
let urls = flickrFavsDelegate.getUrls()
println("\(urls.count) Photos found.")
var url = urls.first!
println("Downloading first Photo from \(url) ...")
let sem = dispatch_semaphore_create(0)

func setDesktopBackground(imgUrl: NSURL) {
    var error : NSError?
    var workspace = NSWorkspace.sharedWorkspace()
    var screen = NSScreen.mainScreen()!
    
    if workspace.setDesktopImageURL(imgUrl, forScreen: screen, options: nil, error: &error) {
        println("Desktop Background successfully set to \(imgUrl.description).")
    } else {
        println("!! Setting Desktop Background failed: \(error?.localizedDescription)")
    }
    dispatch_semaphore_signal(sem);
    
}

func downloadCompleted(location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void {
    if let err = error {
        println("!! Downloading Image failed: \(err.localizedDescription)")
    } else {
        setDesktopBackground(location)
    }
}
var downloadTask = NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string: url)!,
    completionHandler: downloadCompleted)

downloadTask.resume()
dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)

