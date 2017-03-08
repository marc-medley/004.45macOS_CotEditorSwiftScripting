#!/usr/bin/swift
// %%%{CotEditorXInput=NONE}%%%
// %%%{CotEditorXOutput=InsertAfterSelection}%%%
// EXAMPLE ALTERNATE: #!/usr/bin/swift -F /Library/Frameworks -g -target x86_64-apple-macosx10.12

// "List Windows.sh" lists the windows open in the CotEditor

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
    // ... other application features can be added here
}
extension SBApplication: CotEditorApplication {}

@objc public protocol CotEditorWindow: SBObjectProtocol {
    @objc optional var name: String { get } // The title of the window.
    @objc optional func id() -> Int // The unique identifier of the window.
    @objc optional var index: Int { get } // The index of the window, ordered front to back.
    @objc optional func setIndex(_ index: Int) // The index of the window, ordered front to back.
    // ... other window properties can be added here.
}
extension SBObject: CotEditorWindow {}

let cotEditor = SBApplication(bundleIdentifier: "com.coteditor.CotEditor") as! CotEditorApplication

guard let windows = cotEditor.windows!().get() as? [CotEditorWindow] else {
    print(":FAIL: no windows")
    exit(1) // Swift script uses `exit(n)` instead of `return`
}

for w in windows {
    let id: Int = w.id!()
    let index: Int = w.index!
    let name: String = w.name!
    print("window index:\(index) id:\(id) name:\(name)")
}

