#!/usr/bin/swift
// %%%{CotEditorXInput=NONE}%%%
// %%%{CotEditorXOutput=InsertAfterSelection}%%%
// EXAMPLE ALTERNATE: #!/usr/bin/swift -F /Library/Frameworks -g -target x86_64-apple-macosx10.12

// "List URL.sh" lists the URL for each document.

import Foundation
import AppKit
import ScriptingBridge

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
    // ... other Application features can be added here
}
extension SBApplication: CotEditorApplication {}

@objc public protocol CotEditorDocument: SBObjectProtocol {
    @objc optional var name: String { get } // Its name.
    @objc optional var modified: Bool { get } // Has it been modified since the last save?
    @objc optional var file: URL? { get } // Its location on disk, if it has one.
    @objc optional func findFor(_ for_: String, backwards: Bool, ignoreCase: Bool, RE: Bool, wrap: Bool) -> Bool // Search text.
    @objc optional func replaceFor(_ for_: String, to: String, all: Bool, backwards: Bool, ignoreCase: Bool, RE: Bool, wrap: Bool) -> Int // Replace text.
    @objc optional var coloringStyle: String { get } // The current syntax style name.
    // ... other Document features can be added here    
}
extension SBObject: CotEditorDocument {}

let cotEditor = SBApplication(bundleIdentifier: "com.coteditor.CotEditor") as! CotEditorApplication

guard let documents = cotEditor.documents!().get() as? [CotEditorDocument] else {
    print(":FAIL: no documents")
    exit(1) // Swift script uses `exit(n)` instead of `return`
}

for doc in documents {
    let modified: Bool = doc.modified!
    let name: String = doc.name!
    let style: String = doc.coloringStyle!
    
    let url: URL?? = doc.file
    
    if let a = url {
        if let b = a {
            print("document modified=\(modified) style=\(style) name=\(name) url=\(b)")
            // documents with a URL print here `file:///path/to/file.ext`
        }
        else {
            print("document modified=\(modified) style=\(style) name=\(name) url=\(a)")
            // new, never saved documents print here with `nil`
        }
    }
}

