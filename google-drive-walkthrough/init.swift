// Author: Emmanuel Odeke <emm.odeke@gmail.com>

import Foundation
import Swift

let dependencies = [
    "https://github.com/google/google-api-objectivec-client.git",
    "https://github.com/google/gtm-oauth2.git",
    "https://github.com/google/gtm-session-fetcher.git",
    "https://github.com/stig/json-framework.git -b v2.3",
]

let copies = [
    "gtm-oauth2/Source google-api-objectivec-client/Source/OAuth2",
    "json-framework/Classes google-api-objectivec-client/Source/JSON",
]

func main() {
    var cpOp = Operation(launchPath: "/usr/bin/cp")
    var gitOp = Operation(launchPath: "/usr/bin/git")

    for dep in dependencies {
        let fatal = opRunner(gitOp, argv: "clone", dep)
        if fatal && false {
            return
        }
    }

    for copv in copies {
        let fatal = opRunner(cpOp, argv: "-R", copv)
        if fatal && false {
            return
        }
    }
}

func opRunner(op: Operation, argv: String...) -> Bool {
    var err = op.run(argv)
    if err == nil {
        return false
    }
        
    print("\(err)") 
    return true
}

enum OperationError: ErrorType {
    case Common(message: String, statusCode: Int)
}

class Operation {
    let launchPath: String
    init(launchPath: String) {
        self.launchPath = launchPath
    }

    func run(argv: [String]) -> OperationError? {
        return shellOut(self.launchPath, argv: argv)
    }
}

func shellOut(launchPath: String, argv: [String]) -> OperationError? {
    let task = NSTask()
    task.launchPath = launchPath
    task.arguments = argv

    let pipe = NSPipe()
    task.standardOutput = pipe
    task.standardError = pipe

    task.launch()
    task.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = String(NSString(data: data, encoding: NSUTF8StringEncoding))
    
    if output.characters.count < 1 {
        return nil
    }

    return OperationError.Common(message: output, statusCode: -1)
}

main()
/*
let processInfo = NSProcessInfo.processInfo()
let arguments = NSProcessInfo.processInfo().arguments
print(arguments)
if arguments[0] == __FILE__ {
    main()
}
*/
