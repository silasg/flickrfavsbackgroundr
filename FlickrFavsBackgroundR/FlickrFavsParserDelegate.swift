//
//  FlickrFavsParserDelegate.swift
//  FlickrFavsBackgroundR
//
//  Created by Silas Graffy on 06/02/15.
//  Copyright (c) 2015 Silas Graffy. All rights reserved.
//

import Foundation

public class FlickrFavsParserDelegate: NSObject, NSXMLParserDelegate {
    var imgUrls = [(Int, String)]()
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
        if elementName == "photo" {
            if let pic: AnyObject = attributeDict["url_k"] {
                let dateFaved = attributeDict["date_faved"]!.description.toInt()!
                imgUrls.append((dateFaved, pic.description))
            }
        }
    }
    
    public func getUrls() -> Array<String> {
        return imgUrls.sorted { $0.0 > $1.0 }.map {$0.1} 
    }
}