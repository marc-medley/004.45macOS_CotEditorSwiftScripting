#!/usr/bin/swift
// %%%{CotEditorXInput=AllText}%%%
// %%%{CotEditorXOutput=ReplaceAllText}%%%

import Foundation

func setEnvironmentVar(key: String, value: String, overwrite: Bool = false) {
    setenv(key, value, overwrite ? 1 : 0)
}

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

// XMLLINT_INDENT=$'  ' xmllint --format --encode utf-8 -
// Use `which -a xmllint` to find install location
// e.g. /usr/bin/xmllint or /opt/local/bin/xmllint
/// full command path required
let commandPath = "/usr/bin/xmllint" 

/// comment/uncomment arguments as needed
var args = [String]()
args.append("--format")
args.append(contentsOf: ["--encode", "utf-8"])
args.append("-")

// four spaces
setEnvironmentVar(key: "XMLLINT_INDENT", value: "    ")

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

