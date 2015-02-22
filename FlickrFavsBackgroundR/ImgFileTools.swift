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
        // TODO: Refactoring hier und gar nicht erst runterladen, wenn das Bild schon da ist
        let imageFolder = "\(NSHomeDirectory())/Library/FlickrBackgroundR/"
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
                setWallpaperToImageFile(dest)
            } else {
                println("!! Move file failed: \(error!.localizedDescription)")
            }
        } else {
            println("File \(dest) already exists.")
            let existingFiles = fm.contentsOfDirectoryAtPath(imageFolder, error: &error)?.filter { (s) in s.substringToIndex(1) != "." }
            if error == nil {
                let imgCount = existingFiles!.count
                println ("Seeting one of \(imgCount) images as wallpaper ...")
                let picIndex = Int(arc4random_uniform(UInt32(imgCount)))
                let picFile = imageFolder + existingFiles![picIndex].description
                setWallpaperToImageFile(picFile)
            } else {
                println("!! Getting existing files failed: \(error!.localizedDescription)")
            }
            
        }
    }
    
    private class func setWallpaperToImageFile(imgPath: String) {
        var error : NSError?
        let workspace = NSWorkspace.sharedWorkspace()
        let mainScreen = NSScreen.mainScreen()!
        let imgUrl = NSURL(fileURLWithPath: imgPath)!
        
        if workspace.setDesktopImageURL(imgUrl, forScreen: mainScreen, options: nil, error: &error) {
            println("Wallpaper successfully set to \(imgPath).")
        } else {
            println("!! Setting wallpaper to \(imgPath) failed: \(error!.localizedDescription)")
        }
    }
    
}
