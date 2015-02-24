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
    let imageLibrary: FlickrFavsLibrary
    let sem = dispatch_semaphore_create(0)

    init(flickrApiKey: String, flickrUserId: String, libraryPath: String, flickrFetchCount: Int = 100) {
        self.flickrApiKey = flickrApiKey
        self.flickrUserId = flickrUserId
        self.flickrFetchCount = flickrFetchCount
        self.imageLibrary = FlickrFavsLibrary(libraryPath: libraryPath)
    }
    
    public func go() {
        let flickrFavsDelegate = FlickrFavsParserDelegate()
        let xmlParser = createParser(flickrFavsDelegate)
        
        println("Getting and parsing favorite photos of Flickr user '\(flickrUserId)' with size 'k' (2048 px min) ...")
        xmlParser.parse()
        
        let urls = flickrFavsDelegate.getUrls()
        println("\(urls.count) photos found.")
        
        if let url = urls.first {
            let fileName = url.lastPathComponent
            if !imageLibrary.contains(fileName) {
                println("Downloading first photo from \(url) ...")
                downloadAsync(url, callback: downloadCompleted)
                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
            } else {
                println("Latest photo \(fileName) is already in library.")
                imageLibrary.setRandomExistingWallpaper()
            }
        }
        
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
            exit(11)
        } else {
            let origPath = location.path!
            let nameInLibrary = response.URL!.lastPathComponent!
            imageLibrary.moveInLibrary(origPath, nameInLibrary: nameInLibrary)
        }
        dispatch_semaphore_signal(sem);
    }
}