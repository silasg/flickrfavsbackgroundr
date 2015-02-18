//
//  FlickrFavsBackgroundR.swift
//  FlickrFavsBackgroundR
//
//  Created by Silas Graffy on 16/02/15.
//  Copyright (c) 2015 Silas Graffy. All rights reserved.
//

import Foundation
import Cocoa

public class FlickFavsBackgroudR {

    let flickrApiKey: String
    let flickrUserId: String
    let flickrFetchCount: Int
    let sem = dispatch_semaphore_create(0)

    init(flickrApiKey: String, flickrUserId: String, flickrFetchCount: Int = 100) {
        self.flickrApiKey = flickrApiKey
        self.flickrUserId = flickrUserId
        self.flickrFetchCount = flickrFetchCount
    }
    
    public func go() {
        let flickrFavsDelegate = FlickrFavsParserDelegate()
        let xmlParser = createParser(flickrFavsDelegate)
        println("Getting and parsing Favorite Photos of Flickr User '\(flickrUserId)' with Size 'k' (2048 px min)...")
        xmlParser.parse()
        let urls = flickrFavsDelegate.getUrls()
        println("\(urls.count) Photos found.")
        
        if let url = urls.first {
            println("Downloading first Photo from \(url) ...")
            downloadAsync(url, callback: setWallpaperToDownloadResult)
        }
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
    }
    
    private func createParser(delegate: NSXMLParserDelegate) -> NSXMLParser {
        let flickrRestUrl = "https://api.flickr.com/services/rest/?method=flickr.favorites.getPublicList&api_key=\(flickrApiKey)&user_id=\(flickrUserId)&per_page=\(flickrFetchCount)&extras=url_k"
        let flickrFavsUrl = NSURL(string: flickrRestUrl)
        let xmlParser = NSXMLParser(contentsOfURL: flickrFavsUrl)!
        xmlParser.delegate = delegate
        return xmlParser
    }
    
    private func downloadAsync(url: String, callback: ((NSURL!, NSURLResponse!, NSError!) -> Void)?) {
        let downloadTask = NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string: url)!,
            completionHandler: callback)
        downloadTask.resume()
    }
    
    private func setWallpaperToDownloadResult(location: NSURL!, response: NSURLResponse!, error: NSError!) {
        if let err = error {
            println("!! Downloading Image failed: \(err.localizedDescription)")
        } else {
            setWallpaperToImageFile(location)
        }
    }
    
    private func setWallpaperToImageFile(imgUrl: NSURL) {
        var error : NSError?
        let workspace = NSWorkspace.sharedWorkspace()
        let mainScreen = NSScreen.mainScreen()!
        
        if workspace.setDesktopImageURL(imgUrl, forScreen: mainScreen, options: nil, error: &error) {
            println("Desktop Background successfully set to \(imgUrl.description).")
        } else {
            println("!! Setting Desktop Background failed: \(error!.localizedDescription)")
        }
        dispatch_semaphore_signal(sem);        
    }
}