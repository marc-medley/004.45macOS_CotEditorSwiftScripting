#!/usr/bin/swift
// %%%{CotEditorXInput=AllText}%%%
// %%%{CotEditorXOutput=ReplaceAllText}%%%

/// Uses MacPorts install of http://www.html-tidy.org/
/// https://github.com/macports/macports-ports/blob/master/www/tidy/Portfile
/// `sudo port install tidy`

import Foundation

var jsonString: String = ""
var i = 0
while true {
    let line = readLine(strippingNewline: true)
    if line == nil { break }
    if line == "" { continue } // `break` or `continue`
    if let s = line {
      jsonString.append(s)
      // uncomment to view input
      // print("line[\(i)] \(s)")
      i = i + 1
    }
}

let xmlData = jsonString.data(using: String.Encoding.utf8)!

if let data: Data = jsonString.data(using: .utf8) {
    
    do {
        let jsonInObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        let jsonOutData = try JSONSerialization.data(withJSONObject: jsonInObject, options: [])
        let jsonOutString = String(data: jsonOutData, encoding: String.Encoding.utf8)!
        
        print(jsonOutString)
        
    }
    catch {
        print("ERROR: CONVERSION FAILED")
        print(jsonString)
    }
    
}


// NOTES:
//
// JSONSerialization.ReadingOptions: 
//   mutableContainers - arrays and dictionaries are created as mutable objects.
//   mutableLeaves - graph leaf strings are created as NSMutableString
//   allowFragments - allow top-level objects that are not an instance of NSArray or NSDictionary. 
//
// JSONSerialization.ReadingOptions:
//   prettyPrinted : add readable white space
//   [default] : most compact possible
