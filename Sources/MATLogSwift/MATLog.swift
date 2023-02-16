//
//  MATLogSwift.swift
//  MATLog
//
//  Created by xq on 2023/2/16.
//

@_exported import MATLog

/**
 + (void)log:(BOOL)asynchronous
    isUpload:(BOOL)isUpload
       level:(MATLogLevel)level
        flag:(MATLogFlag)flag
  moduleType:(NSInteger)type
     message:(NSString *)message
        {
     
 }
 */

private extension MATLogLevel {
    func toDDLogLevel() -> DDLogLevel {
        switch self {
        case .error:
            return .error
        case .warning:
            return .warning
        case .info:
            return .info
        case .debug:
            return .debug
        case .verbose:
            return .verbose
        case .all:
            return .all
        case .off:
            return .off
        @unknown default:
            return .debug
        }
    }
}

private extension MATLogFlag {
    func toDDLogFlag() -> DDLogFlag {
        return .verbose
    }
}

//@inlinable
public func _MATLogLogMessage(_ message: @autoclosure () -> Any,
                   asynchronous: Bool,
                       isUpload: Bool,
                          level: MATLogLevel,
                           flag: MATLogFlag,
                     moduleType: Int,
                           file: StaticString,
                       function: StaticString,
                           line: UInt) {
    if (isUpload) {
        //TODO:上传服务器
    }
    let ddLevel = level.toDDLogLevel()
    let ddFlag = flag.toDDLogFlag()
    if ((ddLevel.rawValue & ddFlag.rawValue) != 0) {
        // Tell the DDLogMessage constructor to copy the C strings that get passed to it.
        let logMessage = DDLogMessage(message: String(describing: message()),
                                      level: ddLevel,
                                      flag: ddFlag,
                                      context: moduleType,
                                      file: String(describing: file),
                                      function: String(describing: function),
                                      line: line,
                                      tag: nil,
                                      options: [.copyFile, .copyFunction],
                                      timestamp: nil)
        DDLog.sharedInstance.log(asynchronous: asynchronous, message: logMessage)
    }
}
