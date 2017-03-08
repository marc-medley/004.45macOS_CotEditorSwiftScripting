import Foundation
import AppKit
import ScriptingBridge

@objc
public protocol SBObjectProtocol: NSObjectProtocol {
    func get() -> Any!
}

@objc
public protocol SBApplicationProtocol: SBObjectProtocol {
    func activate()
    var delegate: SBApplicationDelegate! { get set }
    var running: Bool { @objc(isRunning) get }
}

/*
 * CotEditor.h
 */

// MARK: CotEditorSaveOptions
@objc public enum CotEditorSaveOptions : AEKeyword {
    case yes = 0x79657320 /* 'yes ' */ // Save the file. 
    case no = 0x6e6f2020 /* 'no  ' */ // Do not save the file. 
    case ask = 0x61736b20 /* 'ask ' */ // Ask the user whether or not to save the file. 
}

// MARK: CotEditorPrintingErrorHandling
@objc public enum CotEditorPrintingErrorHandling : AEKeyword {
    case standard = 0x6c777374 /* 'lwst' */ // Standard PostScript error handling 
    case detailed = 0x6c776474 /* 'lwdt' */ // print a detailed report of PostScript errors 
}

// MARK: CotEditorSaveableFileFormat
@objc public enum CotEditorSaveableFileFormat : AEKeyword {
    case text = 0x54585420 /* 'TXT ' */ // The plain text. 
}

// MARK: CotEditorLineEndingCharacter
@objc public enum CotEditorLineEndingCharacter : AEKeyword {
    case lf = 0x6c654c46 /* 'leLF' */ // macOS / Unix (LF) 
    case cr = 0x6c654352 /* 'leCR' */ // Classic Mac OS (CR) 
    case crlf = 0x6c65434c /* 'leCL' */ // Windows (CR/LF) 
}

// MARK: CotEditorCaseType
@objc public enum CotEditorCaseType : AEKeyword {
    case capitalized = 0x63436370 /* 'cCcp' */
    case lower = 0x63436c77 /* 'cClw' */
    case upper = 0x63437570 /* 'cCup' */
}

// MARK: CotEditorKanaType
@objc public enum CotEditorKanaType : AEKeyword {
    case hiragana = 0x6348676e /* 'cHgn' */
    case katakana = 0x634b6b6e /* 'cKkn' */
}

// MARK: CotEditorUNFType
@objc public enum CotEditorUNFType : AEKeyword {
    case nfc = 0x634e6663 /* 'cNfc' */
    case nfd = 0x634e6664 /* 'cNfd' */
    case nfkc = 0x634e6b63 /* 'cNkc' */
    case nfkd = 0x634e6b64 /* 'cNkd' */
    case nfkcCasefold = 0x634e6366 /* 'cNcf' */
    case modifiedNFC = 0x634e6d63 /* 'cNmc' */
    case modifiedNFD = 0x634e666d /* 'cNfm' */
}

// MARK: CotEditorCharacterWidthType
@objc public enum CotEditorCharacterWidthType : AEKeyword {
    case full = 0x7257666c /* 'rWfl' */
    case half = 0x72576866 /* 'rWhf' */
}

// MARK: @protocol CotEditorGenericMethods
@objc public protocol CotEditorGenericMethods {
    @objc optional func closeSaving(_ saving: CotEditorSaveOptions, savingIn: URL) // Close a document.
    @objc optional func saveIn(_ in_: URL, as: CotEditorSaveableFileFormat) // Save a document.
    @objc optional func printWithProperties(_ withProperties: [AnyHashable: Any]!, printDialog: Bool) // Print a document.
    @objc optional func delete() // Delete an object.
    @objc optional func duplicateTo(_ to: SBObject!, withProperties: [AnyHashable: Any]!) // Copy an object.
    @objc optional func moveTo(_ to: SBObject!) // Move an object to a new location.
}



/*
 * Standard Suite
 */

// The application's top-level scripting object.
// MARK: @interface CotEditorApplication
@objc public protocol CotEditorApplication: SBApplicationProtocol {
    @objc optional func documents() -> SBElementArray
    @objc optional func windows() -> SBElementArray
    @objc optional var name: String { get } // The name of the application.
    @objc optional var frontmost: Bool { get } // Is this the active application?
    @objc optional var version: String { get } // The version number of the application.
    @objc optional func open(_ x: Any!) -> Any // Open a document.
    @objc optional func print(_ x: Any!, withProperties: [AnyHashable: Any]!, printDialog: Bool) // Print a document.
    @objc optional func quitSaving(_ saving: CotEditorSaveOptions) // Quit the application.
    @objc optional func exists(_ x: Any!) -> Bool // Verify that an object exists.
}
extension SBApplication: CotEditorApplication {}

// A document.
// MARK: @interface CotEditorDocument
@objc public protocol CotEditorDocument: SBObjectProtocol, CotEditorGenericMethods {
    @objc optional var name: String { get } // Its name.
    @objc optional var modified: Bool { get } // Has it been modified since the last save?
    @objc optional var file: URL? { get } // Its location on disk, if it has one.
    @objc optional func convertLossy(_ lossy: Bool, to: String) -> Bool // Convert the document text to new encoding.
    @objc optional func findFor(_ for_: String, backwards: Bool, ignoreCase: Bool, RE: Bool, wrap: Bool) -> Bool // Search text.
    @objc optional func reinterpretAs(_ as: String) -> Bool // Reinterpret the document text as new encoding.
    @objc optional func replaceFor(_ for_: String, to: String, all: Bool, backwards: Bool, ignoreCase: Bool, RE: Bool, wrap: Bool) -> Int // Replace text.
    @objc optional func scrollToCaret() // Scroll document to caret or selected text.
    @objc optional func stringIn(_ in_: [Any]!) -> String // Get text in desired range.
    
    // CotEditorDocument CotEditorSuite
    @objc optional var text: CotEditorAttributeRun { get } // The whole text of the document.
    @objc optional func setText(_ text: CotEditorAttributeRun!) // The whole text of the document.
    @objc optional var coloringStyle: String { get } // The current syntax style name.
    @objc optional func setColoringStyle(_ coloringStyle: String!) // The current syntax style name.
    /// The contents of the document.
    @objc optional var contents: CotEditorAttributeRun { get } // The contents of the document.
    @objc optional func setContents(_ contents: CotEditorAttributeRun!) // The contents of the document.
    @objc optional var encoding: String { get } // The encoding name of the document.
    @objc optional var IANACharset: String { get } // The IANA charset name of the document.
    @objc optional var length: Int { get } // The number of characters in the document.
    @objc optional var lineEnding: CotEditorLineEndingCharacter { get } // The line ending type of the document.
    @objc optional func setLineEnding(_ lineEnding: CotEditorLineEndingCharacter) // The line ending type of the document.
    @objc optional var tabWidth: Int { get } // The width of a tab character in space equivalents.
    @objc optional func setTabWidth(_ tabWidth: Int) // The width of a tab character in space equivalents.
    @objc optional var expandsTab: Bool { get } // Are tab characters expanded to space?
    @objc optional func setExpandsTab(_ expandsTab: Bool) // Are tab characters expanded to space?
    @objc optional var selection: CotEditorTextSelection { get } // The current selection.
    @objc optional func setSelection(_ selection: CotEditorTextSelection!) // The current selection.
    @objc optional var wrapLines: Bool { get } // Are lines wrapped?
    @objc optional func setWrapLines(_ wrapLines: Bool) // Are lines wrapped?
}
extension SBObject: CotEditorDocument {}

// A window.
// MARK: @interface CotEditorWindow
@objc public protocol CotEditorWindow: SBObjectProtocol, CotEditorGenericMethods {
    @objc optional var name: String { get } // The title of the window.
    @objc optional func id() -> Int // The unique identifier of the window.
    @objc optional var index: Int { get } // The index of the window, ordered front to back.
    @objc optional func setIndex(_ index: Int) // The index of the window, ordered front to back.
    @objc optional var bounds: NSRect { get } // The bounding rectangle of the window.
    @objc optional func setBounds(_ bounds: NSRect) // The bounding rectangle of the window.
    @objc optional var closeable: Bool { get } // Does the window have a close button?
    @objc optional var miniaturizable: Bool { get } // Does the window have a minimize button?
    @objc optional var miniaturized: Bool { get } // Is the window minimized right now?
    @objc optional func setMiniaturized(_ miniaturized: Bool) // Is the window minimized right now?
    @objc optional var resizable: Bool { get } // Can the window be resized?
    @objc optional var visible: Bool { get } // Is the window visible right now?
    @objc optional func setVisible(_ visible: Bool) // Is the window visible right now?
    @objc optional var zoomable: Bool { get } // Does the window have a zoom button?
    @objc optional var zoomed: Bool { get } // Is the window zoomed right now?
    @objc optional func setZoomed(_ zoomed: Bool) // Is the window zoomed right now?
    @objc optional var document: CotEditorDocument { get } // The document whose contents are displayed in the window.
    // CotEditorWindow (CotEditorSuite)
    @objc optional var viewOpacity: Double { get } // The opacity of the text view. (from ‘0.2’ to ‘1.0’)
    @objc optional func setViewOpacity(_ viewOpacity: Double) // The opacity of the text view. (from ‘0.2’ to ‘1.0’)
    
}
extension SBObject: CotEditorWindow {}

// A way to refer to the state of the current selection.
// MARK: @interface CotEditorTextSelection
@objc public protocol CotEditorTextSelection: SBObjectProtocol, CotEditorGenericMethods {
    @objc optional var contents: CotEditorAttributeRun { get } // The contents of the selection.
    @objc optional func setContents(_ contents: CotEditorAttributeRun!) // The contents of the selection.
    @objc optional var lineRange: [NSNumber] { get } // The range of lines of the selection. The format is “{location, length}”.
    @objc optional func setLineRange(_ lineRange: [NSNumber]!) // The range of lines of the selection. The format is “{location, length}”.
    @objc optional var range: [NSNumber] { get } // The range of characters in the selection. The format is “{location, length}”.
    @objc optional func setRange(_ range: [NSNumber]!) // The range of characters in the selection. The format is “{location, length}”.
    @objc optional func changeCaseTo(_ to: CotEditorCaseType) // Change the case of the selection.
    @objc optional func changeKanaTo(_ to: CotEditorKanaType) // Change Japanese “Kana” mode of the selection.
    @objc optional func changeRomanWidthTo(_ to: CotEditorCharacterWidthType) // Change width of Japanese roman characters in the selection.
    @objc optional func shiftLeft() // Shift selected lines to left.
    @objc optional func shiftRight() // Shift selected lines to right.
    @objc optional func moveLineUp() // Swap selected lines with the line just above.
    @objc optional func moveLineDown() // Swap selected lines with the line just below
    @objc optional func sortLines() // Sort selected lines ascending
    @objc optional func reverseLines() // Reverse selected lines
    @objc optional func deleteDuplicateLine() // Delete duplicate lines in selection
    @objc optional func commentOut() // Append comment delimiters to selected text if possible.
    @objc optional func uncomment() // Remove comment delimiters from selected text if possible.
    @objc optional func normalizeUnicodeTo(_ to: CotEditorUNFType) // Normalize Unicode.
}
extension SBObject: CotEditorTextSelection {}



/*
 * Text Suite
 */

// Rich (styled) text.
// MARK: @interface CotEditorRichText
@objc public protocol CotEditorRichText: SBObjectProtocol, CotEditorGenericMethods {
    @objc optional func characters() -> SBElementArray
    @objc optional func paragraphs() -> SBElementArray
    @objc optional func words() -> SBElementArray
    @objc optional func attributeRuns() -> SBElementArray
    @objc optional func attachments() -> SBElementArray
    @objc optional var color: NSColor { get } // The color of the text’s first character.
    @objc optional func setColor(_ color: NSColor!) // The color of the text’s first character.
    @objc optional var font: String { get } // The name of the font of the text’s first character.
    @objc optional func setFont(_ font: String!) // The name of the font of the text’s first character.
    @objc optional var size: Int { get } // The size in points of the text’s first character.
    @objc optional func setSize(_ size: Int) // The size in points of the text’s first character.
}
extension SBObject: CotEditorRichText {}

// One of some text’s characters.
// MARK: @interface CotEditorCharacter
@objc public protocol CotEditorCharacter: SBObjectProtocol, CotEditorGenericMethods {
    @objc optional func characters() -> SBElementArray
    @objc optional func paragraphs() -> SBElementArray
    @objc optional func words() -> SBElementArray
    @objc optional func attributeRuns() -> SBElementArray
    @objc optional func attachments() -> SBElementArray
    @objc optional var color: NSColor { get } // Its color.
    @objc optional func setColor(_ color: NSColor!) // Its color.
    @objc optional var font: String { get } // The name of its font.
    @objc optional func setFont(_ font: String!) // The name of its font.
    @objc optional var size: Int { get } // Its size, in points.
    @objc optional func setSize(_ size: Int) // Its size, in points.
}
extension SBObject: CotEditorCharacter {}

// One of some text’s paragraphs.
// MARK: @interface CotEditorParagraph
@objc public protocol CotEditorParagraph: SBObjectProtocol, CotEditorGenericMethods {
    @objc optional func characters() -> SBElementArray
    @objc optional func paragraphs() -> SBElementArray
    @objc optional func words() -> SBElementArray
    @objc optional func attributeRuns() -> SBElementArray
    @objc optional func attachments() -> SBElementArray
    @objc optional var color: NSColor { get } // The color of the paragraph’s first character.
    @objc optional func setColor(_ color: NSColor!) // The color of the paragraph’s first character.
    @objc optional var font: String { get } // The name of the font of the paragraph’s first character.
    @objc optional func setFont(_ font: String!) // The name of the font of the paragraph’s first character.
    @objc optional var size: Int { get } // The size in points of the paragraph’s first character.
    @objc optional func setSize(_ size: Int) // The size in points of the paragraph’s first character.
}
extension SBObject: CotEditorParagraph {}

// One of some text’s words.
// MARK: @interface CotEditorWord
@objc public protocol CotEditorWord: SBObjectProtocol, CotEditorGenericMethods {
    @objc optional func characters() -> SBElementArray
    @objc optional func paragraphs() -> SBElementArray
    @objc optional func words() -> SBElementArray
    @objc optional func attributeRuns() -> SBElementArray
    @objc optional func attachments() -> SBElementArray
    @objc optional var color: NSColor { get } // The color of the word’s first character.
    @objc optional func setColor(_ color: NSColor!) // The color of the word’s first character.
    @objc optional var font: String { get } // The name of the font of the word’s first character.
    @objc optional func setFont(_ font: String!) // The name of the font of the word’s first character.
    @objc optional var size: Int { get } // The size in points of the word’s first character.
    @objc optional func setSize(_ size: Int) // The size in points of the word’s first character.
}
extension SBObject: CotEditorWord {}

// A chunk of text that all has the same attributes.
// MARK: @interface CotEditorAttributeRun
@objc public protocol CotEditorAttributeRun: SBObjectProtocol, CotEditorGenericMethods {
    @objc optional func characters() -> SBElementArray
    @objc optional func paragraphs() -> SBElementArray
    @objc optional func words() -> SBElementArray
    @objc optional func attributeRuns() -> SBElementArray
    @objc optional func attachments() -> SBElementArray
    @objc optional var color: NSColor { get } // Its color.
    @objc optional func setColor(_ color: NSColor!) // Its color.
    @objc optional var font: String { get } // The name of its font.
    @objc optional func setFont(_ font: String!) // The name of its font.
    @objc optional var size: Int { get } // Its size, in points.
    @objc optional func setSize(_ size: Int) // Its size, in points.
}
extension SBObject: CotEditorAttributeRun {}

// A file embedded in text. This is just for use when embedding a file using the make command.
// MARK: @interface CotEditorAttachment
@objc public protocol CotEditorAttachment: CotEditorRichText {
    @objc optional var fileName: String { get } // The path to the embedded file.
    @objc optional func setFileName(_ fileName: String!) // The path to the embedded file.
}
extension SBObject: CotEditorAttachment {}


