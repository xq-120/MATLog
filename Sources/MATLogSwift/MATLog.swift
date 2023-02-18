//
//  MATLogSwift.swift
//  MATLog
//
//  Created by xq on 2023/2/16.
//

@_exported import MATLog

@inlinable
public func _MATLogLogMessage(_ message: @autoclosure () -> Any,
                   asynchronous: Bool,
                       isUpload: Bool,
                          level: MATLogLevel,
                           flag: MATLogFlag,
                     moduleType: Int,
                           file: StaticString,
                       function: StaticString,
                           line: UInt) {
    MATLog.log(asynchronous,
               isUpload: isUpload,
               level: level,
               flag: flag,
               moduleType: moduleType,
               file: String(describing: file),
               function: String(describing: function),
               line: line,
               message: String(describing: message()))
}

@inlinable
public func MATLogError(_ message: @autoclosure () -> Any,
                        asynchronous: Bool = false,
                            isUpload: Bool = false,
                          moduleType: Int = 0,
                                file: StaticString = #file,
                            function: StaticString = #function,
                        line: UInt = #line) {
    _MATLogLogMessage(message(), asynchronous: asynchronous, isUpload: isUpload, level: MATLog.logLevel(), flag: .error, moduleType: moduleType, file: file, function: function, line: line)
}

@inlinable
public func MATLogWarning(_ message: @autoclosure () -> Any,
                        asynchronous: Bool = true,
                            isUpload: Bool = false,
                               level: MATLogLevel = MATLog.logLevel(),
                                flag: MATLogFlag = .warning,
                          moduleType: Int = 0,
                                file: StaticString = #file,
                            function: StaticString = #function,
                        line: UInt = #line) {
    _MATLogLogMessage(message(), asynchronous: asynchronous, isUpload: isUpload, level: MATLog.logLevel(), flag: .warning, moduleType: moduleType, file: file, function: function, line: line)
}

@inlinable
public func MATLogInfo(_ message: @autoclosure () -> Any,
                        asynchronous: Bool = true,
                            isUpload: Bool = false,
                          moduleType: Int = 0,
                                file: StaticString = #file,
                            function: StaticString = #function,
                        line: UInt = #line) {
    _MATLogLogMessage(message(), asynchronous: asynchronous, isUpload: isUpload, level: MATLog.logLevel(), flag: .info, moduleType: moduleType, file: file, function: function, line: line)
}

@inlinable
public func MATLogDebug(_ message: @autoclosure () -> Any,
                        asynchronous: Bool = true,
                            isUpload: Bool = false,
                          moduleType: Int = 0,
                                file: StaticString = #file,
                            function: StaticString = #function,
                        line: UInt = #line) {
    _MATLogLogMessage(message(), asynchronous: asynchronous, isUpload: isUpload, level: MATLog.logLevel(), flag: .debug, moduleType: moduleType, file: file, function: function, line: line)
}

@inlinable
public func MATLogVerbose(_ message: @autoclosure () -> Any,
                        asynchronous: Bool = true,
                            isUpload: Bool = false,
                          moduleType: Int = 0,
                                file: StaticString = #file,
                            function: StaticString = #function,
                        line: UInt = #line) {
    _MATLogLogMessage(message(), asynchronous: asynchronous, isUpload: isUpload, level: MATLog.logLevel(), flag: .verbose, moduleType: moduleType, file: file, function: function, line: line)
}


