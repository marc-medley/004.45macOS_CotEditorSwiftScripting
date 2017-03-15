#!/usr/bin/swift
// %%%{CotEditorXInput=Selection}%%%
// %%%{CotEditorXOutput=InsertAfterSelection}%%%
// EXAMPLE ALTERNATE: #!/usr/bin/swift -F /Library/Frameworks -g -target x86_64-apple-macosx10.12

// This "Hello Swift.sh" illustrates many Swift scripting particulars.

import Foundation

// Functions need to be declared before use in uncompiled Swift scripts. 
func printSwiftVersion() {
    #if swift(>=3.1)
    print("Swift version: 3.1")
    #elseif swift(>=3.0.2)
    print("Swift version: 3.0.2")
    #elseif swift(>=3.0.1)
    print("Swift version: 3.0.1")
    #elseif swift(>=2)
    print("Swift version: 2 ... upgrade required for this script")
    return
    #else
    print("Swift upgrade required for this script")
    return
    #endif
}

func setEnvironmentVar(key: String, value: String, overwrite: Bool = false) {
    setenv(key, value, overwrite ? 1 : 0)
}

print("\n## Hello Swift Scripting")
printSwiftVersion()
print("use `readLine()`, `readLine(strippingNewline: true)` to read from Unix STDIN")
print("use `print()` to write to Unix STDOUT")
print("NOTE: Frameworks search location and/or Xcode SDK to use can be specified in the first line. For example: \n `#!/usr/bin/swift -F /Library/Frameworks -g -target x86_64-apple-macosx10.11`")

print("\n### Command Line Arguments:")
let argc = Int(CommandLine.argc)
print("argc = \(argc)")
var i: Int = 0
while i < argc {
    print("arg[\(i)] = \(CommandLine.arguments[i])")
    i = i + 1
}

print("\nNOTE: an ^d or ^D in STDIN is an OEF `nil` that terminates ALL input.")
print("\n### Selected Lines:")
var line: String? = ""
i = 0
while true {
    line = readLine(strippingNewline: true)
    if line == nil { break }
    if line == "" { continue } // `break` or `continue`
    print("line[\(i)] \(line!)")
    i = i + 1
}

print("\nNOTE: ^d or ^D in STDIN is an OEF `nil` that terminates ALL input.")
print("### Environment Variables:")

setEnvironmentVar(key: "FIND_ME", value: "\"HERE I AM\"")

for key in ProcessInfo.processInfo.environment.keys {
    if let value = ProcessInfo.processInfo.environment[key] {
        print("\(key)==\(value)")
    }
}


