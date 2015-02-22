//
//  ImgFileTools.swift
//  FlickrFavsBackgroundR
//
//  Created by Silas Graffy on 22/02/15.
//  Copyright (c) 2015 Silas Graffy. All rights reserved.
//

import Foundation
import Cocoa

public class ImgFileTools {
    
    public class func setWallpaperToDownloadResult(location: NSURL!, response: NSURLResponse!) {
        let imageFolder = "/Users/silas/Library/FlickrBackgroundR/"
        var error: NSError? = nil
        let fm = NSFileManager.defaultManager()
        if !fm.fileExistsAtPath(imageFolder) {
            fm.createDirectoryAtPath(imageFolder, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
        if let err = error {
            println("!! Creating the directory \(imageFolder) failed: \(error?.localizedDescription)")
        }
        let src = location.path!
        let dest = imageFolder + response.URL!.lastPathComponent!
        if !fm.fileExistsAtPath(dest) {
            println("Moving \(src) to \(dest) ...")
            if fm.moveItemAtPath(src, toPath: dest , error: &error) {
                setWallpaperToImageFile(NSURL(fileURLWithPath: dest)!)
            } else {
                println("!! Move file failed: \(error?.localizedDescription)")
            }
        } else {
            println("File \(dest) already exists.")
            // TODO: random bild auswählen und als Hintergund setzen
        }
    }
    
    private class func setWallpaperToImageFile(imgUrl: NSURL) {
        var error : NSError?
        let workspace = NSWorkspace.sharedWorkspace()
        let mainScreen = NSScreen.mainScreen()!
        
        if workspace.setDesktopImageURL(imgUrl, forScreen: mainScreen, options: nil, error: &error) {
            println("Desktop Background successfully set to \(imgUrl.description).")
        } else {
            println("!! Setting Desktop Background failed: \(error!.localizedDescription)")
        }
    }
    
}
