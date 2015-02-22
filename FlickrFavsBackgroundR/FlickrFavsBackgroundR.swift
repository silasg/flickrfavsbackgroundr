//
//  FlickrFavsBackgroundR.swift
//  FlickrFavsBackgroundR
//
//  Created by Silas Graffy on 16/02/15.
//  Copyright (c) 2015 Silas Graffy. All rights reserved.
//

import Foundation

public class FlickrFavsBackgroudR {

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
            downloadAsync(url, callback: downloadCompleted)
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
    
    private func downloadCompleted(location: NSURL!, response: NSURLResponse!, error: NSError!) {
        if let err = error {
            println("!! Downloading Image failed: \(err.localizedDescription)")
        } else {
            ImgFileTools.setWallpaperToDownloadResult(location, response: response)
        }
        dispatch_semaphore_signal(sem);
    }
}