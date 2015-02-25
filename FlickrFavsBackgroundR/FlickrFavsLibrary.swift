//
//  ImgFileTools.swift
//  FlickrFavsBackgroundR
//
//  Created by Silas Graffy on 22/02/15.
//  Copyright (c) 2015 Silas Graffy. All rights reserved.
//

import Foundation
import Cocoa

public class FlickrFavsLibrary {
    
    private let libraryPath : String
    private let fm = NSFileManager.defaultManager()
    
    public init(libraryPath: String) {
        self.libraryPath = libraryPath
        
        var error: NSError? = nil
        if !fm.fileExistsAtPath(libraryPath) {
            println("Creating library folder at \(libraryPath) ...")
            fm.createDirectoryAtPath(libraryPath, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
        if let err = error {
            println("!! Creating library folder \(libraryPath) failed: \(error?.localizedDescription)")
            exit(21)
        }
        
    }
    
    public func contains(fileName: String) -> Bool {
        return fm.fileExistsAtPath(libraryPath + fileName)
    }
    
    public func moveInLibrary(path: String, nameInLibrary: String) {
        var error: NSError? = nil
        let dest = libraryPath + nameInLibrary
        println("Moving \(path) to \(dest) ...")
        if !fm.moveItemAtPath(path, toPath: dest , error: &error) {
            println("!! Move file failed: \(error!.localizedDescription)")
            exit(22)
        }
    }
    
    public func setRandomExistingWallpaper() {
        var error: NSError? = nil
        let existingFiles = fm.contentsOfDirectoryAtPath(libraryPath, error: &error)?.filter { (s) in s.substringToIndex(1) != "." }
        if error == nil {
            let imgCount = existingFiles!.count
            println ("Choosing one of \(imgCount) existing images as wallpaper by random ...")
            let picIndex = Int(arc4random_uniform(UInt32(imgCount)))
            let picFile = libraryPath + existingFiles![picIndex].description
            setWallpaperToPath(picFile)
        } else {
            println("!! Getting existing files failed: \(error!.localizedDescription)")
            exit(23)
        }
    }
    
    public func setWallpaper(nameInLibrary: String) {
        let path = libraryPath + nameInLibrary
        println("Setting wallpaper to \(path) ...")
        setWallpaperToPath(path)
    }
    
    private func setWallpaperToPath(imgPath: String) {
        var error : NSError?
        let workspace = NSWorkspace.sharedWorkspace()
        let imgUrl = NSURL(fileURLWithPath: imgPath)!
        if let screens = NSScreen.screens() {
            for screen in screens.map({ $0 as NSScreen }) {
                if workspace.setDesktopImageURL(imgUrl, forScreen: screen, options: nil, error: &error) {
                    println("Wallpaper at \(screen) successfully set to \(imgPath).")
                } else {
                    println("!! Setting wallpaper at \(screen) to \(imgPath) failed: \(error!.localizedDescription)")
                }
            }
        } else {
            println("!! No screens found.")
            exit(24)
        }
    }
}
