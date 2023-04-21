//
//  Logger.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/30/22.
//

import Foundation



class Logger {
    func log(method: String, className: String, message: Any) {
//        NSLog(@"💜 Navigation controller Will appear: %@", NSStringFromClass([self class]));
//        NSLog(@"\e[1;31mRed text here\e[m normal text here", NSString("dcdscsd"));
    





    }
}

enum Log {
    enum LogLevel: String {
    case info
    case warning
    case error
        
    fileprivate var prefix: String {
            switch self {
            case .info:
               return "INFO 📝"
            case .warning:
               return "WARN ⚠️"
            case .error:
               return "ALERT ❌"
            }
        }
    }
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        var description : String {
            return " \((file as NSString).lastPathComponent): \(line) \(function)"
        }
      
    }

   static func info(_ str: StaticString, shouldLogContext: Bool = true, file: String = #file , function: String = #function , line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        handleLog(level: .info, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    static func error(_ str: StaticString, shouldLogContext: Bool = true, file: String = #file , function: String = #function , line: Int = #line) {
         let context = Context(file: file, function: function, line: line)
        handleLog(level: .error, str: str.description, shouldLogContext: shouldLogContext, context: context)
     }
    static func warning(_ str: StaticString, shouldLogContext: Bool = true, file: String = #file , function: String = #function , line: Int = #line) {
         let context = Context(file: file, function: function, line: line)
         handleLog(level: .warning, str: str.description, shouldLogContext: shouldLogContext, context: context)
     }
     
     
    

    fileprivate static func handleLog(level: LogLevel, str: String, shouldLogContext: Bool, context: Context ) {
        let logCompenents = ["[\(level.prefix)] ->", str]
        
        var fullString = logCompenents.joined(separator: " ")
        if shouldLogContext {
            fullString += "\(context.description)"
        }
        
        #if DEBUG
        print(fullString)
        #endif
    }

}


