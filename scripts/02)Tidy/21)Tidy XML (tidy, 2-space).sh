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

/// full command path required
let commandPath = "/opt/local/bin/tidy" 

/// comment/uncomment arguments as needed
var args = [String]()
args.append("-xml")      // specify that input is well formed XML
args.append("-indent")   // indent element content
args.append("-quiet")    // suppress nonessential output
//args.append("-upper")    // force tags to upper case
// configuration options
args.append(contentsOf: ["--doctype", "omit"])
args.append(contentsOf: ["--indent-with-tabs", "false"])  
args.append(contentsOf: ["--literal-attributes", "true"]) 
args.append(contentsOf: ["--show-body-only", "true"])   
args.append(contentsOf: ["--show-warnings", "false"])   
args.append(contentsOf: ["--vertical-space", "false"]) 
args.append(contentsOf: ["--wrap", "0"]) // wrap text at the specified <column>


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
// let dataError = stderrPipe.fileHandleForReading.readDataToEndOfFile()
// if let outputError = String(data: dataError, encoding: String.Encoding.utf8) {
//     print("STANDARD ERROR \n" + outputError)
// }

process.waitUntilExit()

/** Uncomment to include status in stdout output */ 
// let status = process.terminationStatus
// print("STATUS: \(status)")
