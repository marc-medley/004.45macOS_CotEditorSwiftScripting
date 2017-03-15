#!/usr/bin/swift
// %%%{CotEditorXInput=None}%%%
// %%%{CotEditorXOutput=Pasteboard}%%%
// Output: `AppendToAllText`, `Pasteboard`, `Discard`

// NOTE: check the pasteboard for output errors.

// "List Windows.sh" lists the windows open in the CotEditor

import Foundation
import AppKit
import ScriptingBridge

func unwrapFilePath(url: URL??) -> String? {
    if let a = url {
        if let b = a {
            // print(":DEBUG: url b=\(b)")
            // file with URL e.g. `file:///path/to/file.ext`
            return b.path
        }
        else {
            //print(":DEBUG: url a=\(a)")
            // new, never saved documents url here with `nil`
            return nil
        }
    }
    else {
        // should not occur
        return nil
    }
}


@objc public protocol SBObjectProtocol: NSObjectProtocol {
    func get() -> Any!
}

@objc public protocol SBApplicationProtocol: SBObjectProtocol {
    func activate()
    var delegate: SBApplicationDelegate! { get set }
    var running: Bool { @objc(isRunning) get }
}

@objc public protocol CotEditorApplication: SBApplicationProtocol {
    @objc optional func documents() -> SBElementArray
    @objc optional func windows() -> SBElementArray
    // ... other application features can be added here
}
extension SBApplication: CotEditorApplication {}

@objc public protocol CotEditorDocument: SBObjectProtocol {
    @objc optional var name: String { get } // Its name.
    @objc optional var modified: Bool { get } // Has it been modified since the last save?
    @objc optional var file: URL? { get } // Its location on disk, if it has one.
    // ... other Document features can be added here    
}
extension SBObject: CotEditorDocument {}

@objc public protocol CotEditorWindow: SBObjectProtocol {
    @objc optional var name: String { get } // The title of the window.
    @objc optional func id() -> Int // The unique identifier of the window.
    @objc optional var index: Int { get } // The index of the window, ordered front to back.
    @objc optional var document: CotEditorDocument { get } // The document whose contents are displayed in the window.
    // ... other window properties can be added here.
}
extension SBObject: CotEditorWindow {}

let cotEditor = SBApplication(bundleIdentifier: "com.coteditor.CotEditor") as! CotEditorApplication

// retrieve windows list
guard let windows = cotEditor.windows!().get() as? [CotEditorWindow] else {
    print(":ERROR: 'Compare 2 Front Windows' no windows")
    exit(1) // Swift script uses `exit(n)` instead of `return`
}

// retrieve first two windows
guard windows.count >= 2 else {
        print(":ERROR: 'Compare 2 Front Windows' two windows?")
        exit(2)// return
}        
let window0 = windows[0]
let window1 = windows[1] 

guard let document0 = window0.document, 
    let document1 = window1.document else {
        print(":ERROR: 'Compare 2 Front Windows' could not access documents")
        exit(3) // return
}

if document0.modified == true || document1.modified == true {
        print(":ERROR: 'Compare 2 Front Windows' documents must be saved first")
        exit(4) // return
}

let file_0: URL?? = document0.file
let file_1: URL?? = document1.file

guard let path_0:String = unwrapFilePath(url: file_0), 
    let path_1:String = unwrapFilePath(url: file_1)  else {
        print(":ERROR: 'Compare 2 Front Windows' could not unwrap file url paths. Save documents.")
        exit(5) // return
}

/// full command path required
//let commandPath = "/opt/meld/bin/meld"
let commandPath = "/Applications/Meld.app/Contents/MacOS/Meld"

/// comment/uncomment arguments as needed
var args = [String]()
args.append("\(path_0)")
args.append("\(path_1)")

let process = Process()
process.launchPath = commandPath
process.arguments = args
process.launch()
