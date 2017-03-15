#!/usr/bin/swift
// %%%{CotEditorXInput=AllText}%%%
// %%%{CotEditorXOutput=ReplaceAllText}%%%

/// Uses MacPorts install of http://www.html-tidy.org/
/// https://github.com/macports/macports-ports/blob/master/www/tidy/Portfile
/// `sudo port install tidy`

import Foundation

var xmlString: String = ""
var i = 0
while true {
    let line = readLine(strippingNewline: true)
    if line == nil { break }
    if line == "" { continue } // `break` or `continue`
    if let s = line {
      xmlString.append(s)
      // uncomment to view input
      // print("line[\(i)] \(s)")
      i = i + 1
    }
}

let xmlData = xmlString.data(using: String.Encoding.utf8)!

// full command path required
let commandPath = "/opt/local/bin/tidy" 

// comment/uncommnet arguments as needed
var args = [String]()
args.append("-quiet")    // suppress nonessential output
//args.append("-upper")   // force tags to upper case
args.append("-indent")   // indent element content
args.append(contentsOf: ["--show-warnings", "yes"]) // yes, no  
args.append(contentsOf: ["--wrap", "0"]) // wrap text at the specified <column>
//args.append(contentsOf: ["--doctype", "omit"])
// args.append(contentsOf: ["--show-body-only", "true"])   
// args.append(contentsOf: ["--vertical-space", "no"])  


let process = Process()
process.launchPath = commandPath
process.arguments = args
let stdinPipe = Pipe()
process.standardInput = stdinPipe
let stdoutPipe = Pipe()
process.standardOutput = stdoutPipe
let stderrPipe = Pipe()
process.standardError = stderrPipe
process.launch()

let stdin = stdinPipe.fileHandleForWriting
stdin.write(xmlData)
stdin.closeFile()

let data = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
if let output = String(data: data, encoding: String.Encoding.utf8) {
    // print("STANDARD OUTPUT\n" + output)
    print(output)
}

/** Uncomment to include errors in stdout output */ 
let dataError = stderrPipe.fileHandleForReading.readDataToEndOfFile()
if let outputError = String(data: dataError, encoding: String.Encoding.utf8) {
    if !outputError.isEmpty {
        print("<!-- STANDARD ERROR:\n\(outputError) -->")
    }
}

process.waitUntilExit()

/** Uncomment to include status in stdout output */ 
// let status = process.terminationStatus
// print("<!-- EXIT STATUS: \(status) -->")
