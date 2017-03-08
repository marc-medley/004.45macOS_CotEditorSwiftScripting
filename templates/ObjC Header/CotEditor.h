/*
 * CotEditor.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class CotEditorApplication, CotEditorDocument, CotEditorWindow, CotEditorTextSelection, CotEditorRichText, CotEditorCharacter, CotEditorParagraph, CotEditorWord, CotEditorAttributeRun, CotEditorAttachment;

enum CotEditorSaveOptions {
	CotEditorSaveOptionsYes = 'yes ' /* Save the file. */,
	CotEditorSaveOptionsNo = 'no  ' /* Do not save the file. */,
	CotEditorSaveOptionsAsk = 'ask ' /* Ask the user whether or not to save the file. */
};
typedef enum CotEditorSaveOptions CotEditorSaveOptions;

enum CotEditorPrintingErrorHandling {
	CotEditorPrintingErrorHandlingStandard = 'lwst' /* Standard PostScript error handling */,
	CotEditorPrintingErrorHandlingDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum CotEditorPrintingErrorHandling CotEditorPrintingErrorHandling;

enum CotEditorSaveableFileFormat {
	CotEditorSaveableFileFormatText = 'TXT ' /* The plain text. */
};
typedef enum CotEditorSaveableFileFormat CotEditorSaveableFileFormat;

enum CotEditorLineEndingCharacter {
	CotEditorLineEndingCharacterLF = 'leLF' /* macOS / Unix (LF) */,
	CotEditorLineEndingCharacterCR = 'leCR' /* Classic Mac OS (CR) */,
	CotEditorLineEndingCharacterCRLF = 'leCL' /* Windows (CR/LF) */
};
typedef enum CotEditorLineEndingCharacter CotEditorLineEndingCharacter;

enum CotEditorCaseType {
	CotEditorCaseTypeCapitalized = 'cCcp',
	CotEditorCaseTypeLower = 'cClw',
	CotEditorCaseTypeUpper = 'cCup'
};
typedef enum CotEditorCaseType CotEditorCaseType;

enum CotEditorKanaType {
	CotEditorKanaTypeHiragana = 'cHgn',
	CotEditorKanaTypeKatakana = 'cKkn'
};
typedef enum CotEditorKanaType CotEditorKanaType;

enum CotEditorUNFType {
	CotEditorUNFTypeNFC = 'cNfc',
	CotEditorUNFTypeNFD = 'cNfd',
	CotEditorUNFTypeNFKC = 'cNkc',
	CotEditorUNFTypeNFKD = 'cNkd',
	CotEditorUNFTypeNFKCCasefold = 'cNcf',
	CotEditorUNFTypeModifiedNFC = 'cNmc',
	CotEditorUNFTypeModifiedNFD = 'cNfm'
};
typedef enum CotEditorUNFType CotEditorUNFType;

enum CotEditorCharacterWidthType {
	CotEditorCharacterWidthTypeFull = 'rWfl',
	CotEditorCharacterWidthTypeHalf = 'rWhf'
};
typedef enum CotEditorCharacterWidthType CotEditorCharacterWidthType;

@protocol CotEditorGenericMethods

- (void) closeSaving:(CotEditorSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(CotEditorSaveableFileFormat)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end



/*
 * Standard Suite
 */

// The application's top-level scripting object.
@interface CotEditorApplication : SBApplication

- (SBElementArray<CotEditorDocument *> *) documents;
- (SBElementArray<CotEditorWindow *> *) windows;

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the active application?
@property (copy, readonly) NSString *version;  // The version number of the application.

- (id) open:(id)x;  // Open a document.
- (void) print:(id)x withProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) quitSaving:(CotEditorSaveOptions)saving;  // Quit the application.
- (BOOL) exists:(id)x;  // Verify that an object exists.

@end

// A document.
@interface CotEditorDocument : SBObject <CotEditorGenericMethods>

@property (copy, readonly) NSString *name;  // Its name.
@property (readonly) BOOL modified;  // Has it been modified since the last save?
@property (copy, readonly) NSURL *file;  // Its location on disk, if it has one.

- (BOOL) convertLossy:(BOOL)lossy to:(NSString *)to;  // Convert the document text to new encoding.
- (BOOL) findFor:(NSString *)for_ backwards:(BOOL)backwards ignoreCase:(BOOL)ignoreCase RE:(BOOL)RE wrap:(BOOL)wrap;  // Search text.
- (BOOL) reinterpretAs:(NSString *)as;  // Reinterpret the document text as new encoding.
- (NSInteger) replaceFor:(NSString *)for_ to:(NSString *)to all:(BOOL)all backwards:(BOOL)backwards ignoreCase:(BOOL)ignoreCase RE:(BOOL)RE wrap:(BOOL)wrap;  // Replace text.
- (void) scrollToCaret;  // Scroll document to caret or selected text.
- (NSString *) stringIn:(NSArray<NSNumber *> *)in_;  // Get text in desired range.

@end

// A window.
@interface CotEditorWindow : SBObject <CotEditorGenericMethods>

@property (copy, readonly) NSString *name;  // The title of the window.
- (NSInteger) id;  // The unique identifier of the window.
@property NSInteger index;  // The index of the window, ordered front to back.
@property NSRect bounds;  // The bounding rectangle of the window.
@property (readonly) BOOL closeable;  // Does the window have a close button?
@property (readonly) BOOL miniaturizable;  // Does the window have a minimize button?
@property BOOL miniaturized;  // Is the window minimized right now?
@property (readonly) BOOL resizable;  // Can the window be resized?
@property BOOL visible;  // Is the window visible right now?
@property (readonly) BOOL zoomable;  // Does the window have a zoom button?
@property BOOL zoomed;  // Is the window zoomed right now?
@property (copy, readonly) CotEditorDocument *document;  // The document whose contents are displayed in the window.


@end



/*
 * CotEditor suite
 */

// A CotEditor window.
@interface CotEditorWindow (CotEditorSuite)

@property double viewOpacity;  // The opacity of the text view. (from ‘0.2’ to ‘1.0’)

@end

// A CotEditor document.
@interface CotEditorDocument (CotEditorSuite)

@property (copy) CotEditorAttributeRun *text;  // The whole text of the document.
@property (copy) NSString *coloringStyle;  // The current syntax style name.
@property (copy) CotEditorAttributeRun *contents;  // The contents of the document.
@property (copy, readonly) NSString *encoding;  // The encoding name of the document.
@property (copy, readonly) NSString *IANACharset;  // The IANA charset name of the document.
@property (readonly) NSInteger length;  // The number of characters in the document.
@property CotEditorLineEndingCharacter lineEnding;  // The line ending type of the document.
@property NSInteger tabWidth;  // The width of a tab character in space equivalents.
@property BOOL expandsTab;  // Are tab characters expanded to space?
@property (copy) CotEditorTextSelection *selection;  // The current selection.
@property BOOL wrapLines;  // Are lines wrapped?

@end

// A way to refer to the state of the current selection.
@interface CotEditorTextSelection : SBObject <CotEditorGenericMethods>

@property (copy) CotEditorAttributeRun *contents;  // The contents of the selection.
@property (copy) NSArray<NSNumber *> *lineRange;  // The range of lines of the selection. The format is “{location, length}”.
@property (copy) NSArray<NSNumber *> *range;  // The range of characters in the selection. The format is “{location, length}”.

- (void) changeCaseTo:(CotEditorCaseType)to;  // Change the case of the selection.
- (void) changeKanaTo:(CotEditorKanaType)to;  // Change Japanese “Kana” mode of the selection.
- (void) changeRomanWidthTo:(CotEditorCharacterWidthType)to;  // Change width of Japanese roman characters in the selection.
- (void) shiftLeft;  // Shift selected lines to left.
- (void) shiftRight;  // Shift selected lines to right.
- (void) moveLineUp;  // Swap selected lines with the line just above.
- (void) moveLineDown;  // Swap selected lines with the line just below
- (void) sortLines;  // Sort selected lines ascending
- (void) reverseLines;  // Reverse selected lines
- (void) deleteDuplicateLine;  // Delete duplicate lines in selection
- (void) commentOut;  // Append comment delimiters to selected text if possible.
- (void) uncomment;  // Remove comment delimiters from selected text if possible.
- (void) normalizeUnicodeTo:(CotEditorUNFType)to;  // Normalize Unicode.

@end



/*
 * Text Suite
 */

// Rich (styled) text.
@interface CotEditorRichText : SBObject <CotEditorGenericMethods>

- (SBElementArray<CotEditorCharacter *> *) characters;
- (SBElementArray<CotEditorParagraph *> *) paragraphs;
- (SBElementArray<CotEditorWord *> *) words;
- (SBElementArray<CotEditorAttributeRun *> *) attributeRuns;
- (SBElementArray<CotEditorAttachment *> *) attachments;

@property (copy) NSColor *color;  // The color of the text’s first character.
@property (copy) NSString *font;  // The name of the font of the text’s first character.
@property NSInteger size;  // The size in points of the text’s first character.


@end

// One of some text’s characters.
@interface CotEditorCharacter : SBObject <CotEditorGenericMethods>

- (SBElementArray<CotEditorCharacter *> *) characters;
- (SBElementArray<CotEditorParagraph *> *) paragraphs;
- (SBElementArray<CotEditorWord *> *) words;
- (SBElementArray<CotEditorAttributeRun *> *) attributeRuns;
- (SBElementArray<CotEditorAttachment *> *) attachments;

@property (copy) NSColor *color;  // Its color.
@property (copy) NSString *font;  // The name of its font.
@property NSInteger size;  // Its size, in points.


@end

// One of some text’s paragraphs.
@interface CotEditorParagraph : SBObject <CotEditorGenericMethods>

- (SBElementArray<CotEditorCharacter *> *) characters;
- (SBElementArray<CotEditorParagraph *> *) paragraphs;
- (SBElementArray<CotEditorWord *> *) words;
- (SBElementArray<CotEditorAttributeRun *> *) attributeRuns;
- (SBElementArray<CotEditorAttachment *> *) attachments;

@property (copy) NSColor *color;  // The color of the paragraph’s first character.
@property (copy) NSString *font;  // The name of the font of the paragraph’s first character.
@property NSInteger size;  // The size in points of the paragraph’s first character.


@end

// One of some text’s words.
@interface CotEditorWord : SBObject <CotEditorGenericMethods>

- (SBElementArray<CotEditorCharacter *> *) characters;
- (SBElementArray<CotEditorParagraph *> *) paragraphs;
- (SBElementArray<CotEditorWord *> *) words;
- (SBElementArray<CotEditorAttributeRun *> *) attributeRuns;
- (SBElementArray<CotEditorAttachment *> *) attachments;

@property (copy) NSColor *color;  // The color of the word’s first character.
@property (copy) NSString *font;  // The name of the font of the word’s first character.
@property NSInteger size;  // The size in points of the word’s first character.


@end

// A chunk of text that all has the same attributes.
@interface CotEditorAttributeRun : SBObject <CotEditorGenericMethods>

- (SBElementArray<CotEditorCharacter *> *) characters;
- (SBElementArray<CotEditorParagraph *> *) paragraphs;
- (SBElementArray<CotEditorWord *> *) words;
- (SBElementArray<CotEditorAttributeRun *> *) attributeRuns;
- (SBElementArray<CotEditorAttachment *> *) attachments;

@property (copy) NSColor *color;  // Its color.
@property (copy) NSString *font;  // The name of its font.
@property NSInteger size;  // Its size, in points.


@end

// A file embedded in text. This is just for use when embedding a file using the make command.
@interface CotEditorAttachment : CotEditorRichText

@property (copy) NSString *fileName;  // The path to the embedded file.


@end

