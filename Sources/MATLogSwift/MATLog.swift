//
//  MATLogSwift.swift
//  MATLog
//
//  Created by xq on 2023/2/16.
//

@_exported import MATLog

//private extension MATLogLevel {
//    func toDDLogLevel() -> DDLogLevel {
//        switch self {
//        case .error:
//            return .error
//        case .warning:
//            return .warning
//        case .info:
//            return .info
//        case .debug:
//            return .debug
//        case .verbose:
//            return .verbose
//        case .all:
//            return .all
//        case .off:
//            return .off
//        @unknown default:
//            return .verbose
//        }
//    }
//}
//
//private extension MATLogFlag {
//    func toDDLogFlag() -> DDLogFlag {
//        switch self {
//        case .error:
//            return .error
//        case .warning:
//            return .warning
//        case .info:
//            return .info
//        case .debug:
//            return .debug
//        case .verbose:
//            return .verbose
//        @unknown default:
//            return .verbose
//        }
//    }
//}

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
//    if (isUpload) {
//        //TODO:上传服务器
//    }
//    let ddLevel = MATLog.toDDLogLevel(level)
//    let ddFlag = MATLog.toDDLogFlag(flag)
//    if ((ddLevel.rawValue & ddFlag.rawValue) != 0) {
//        // Tell the DDLogMessage constructor to copy the C strings that get passed to it.
//        let logMessage = DDLogMessage(message: String(describing: message()),
//                                      level: ddLevel,
//                                      flag: ddFlag,
//                                      context: moduleType,
//                                      file: String(describing: file),
//                                      function: String(describing: function),
//                                      line: line,
//                                      tag: nil,
//                                      options: [.copyFile, .copyFunction],
//                                      timestamp: nil)
//        DDLog.sharedInstance.log(asynchronous: asynchronous, message: logMessage)
//    }
}

@inlinable
public func MATLogError(_ message: @autoclosure () -> Any,
                        asynchronous: Bool = false,
                            isUpload: Bool = false,
                               level: MATLogLevel = MATLog.logLevel(),
                                flag: MATLogFlag = .error,
                          moduleType: Int = 0,
                                file: StaticString = #file,
                            function: StaticString = #function,
                        line: UInt = #line) {
    _MATLogLogMessage(message(), asynchronous: asynchronous, isUpload: isUpload, level: level, flag: flag, moduleType: moduleType, file: file, function: function, line: line)
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
    _MATLogLogMessage(message(), asynchronous: asynchronous, isUpload: isUpload, level: level, flag: flag, moduleType: moduleType, file: file, function: function, line: line)
}

@inlinable
public func MATLogInfo(_ message: @autoclosure () -> Any,
                        asynchronous: Bool = true,
                            isUpload: Bool = false,
                               level: MATLogLevel = MATLog.logLevel(),
                                flag: MATLogFlag = .info,
                          moduleType: Int = 0,
                                file: StaticString = #file,
                            function: StaticString = #function,
                        line: UInt = #line) {
    _MATLogLogMessage(message(), asynchronous: asynchronous, isUpload: isUpload, level: level, flag: flag, moduleType: moduleType, file: file, function: function, line: line)
}

@inlinable
public func MATLogDebug(_ message: @autoclosure () -> Any,
                        asynchronous: Bool = true,
                            isUpload: Bool = false,
                               level: MATLogLevel = MATLog.logLevel(),
                                flag: MATLogFlag = .debug,
                          moduleType: Int = 0,
                                file: StaticString = #file,
                            function: StaticString = #function,
                        line: UInt = #line) {
    _MATLogLogMessage(message(), asynchronous: asynchronous, isUpload: isUpload, level: level, flag: flag, moduleType: moduleType, file: file, function: function, line: line)
}

@inlinable
public func MATLogVerbose(_ message: @autoclosure () -> Any,
                        asynchronous: Bool = true,
                            isUpload: Bool = false,
                               level: MATLogLevel = MATLog.logLevel(),
                                flag: MATLogFlag = .verbose,
                          moduleType: Int = 0,
                                file: StaticString = #file,
                            function: StaticString = #function,
                        line: UInt = #line) {
    _MATLogLogMessage(message(), asynchronous: asynchronous, isUpload: isUpload, level: level, flag: flag, moduleType: moduleType, file: file, function: function, line: line)
}


