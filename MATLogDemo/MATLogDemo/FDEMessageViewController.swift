//
//  FDEMessageViewController.swift
//  MATLogDemo
//
//  Created by xq on 2023/2/16.
//

import UIKit
import MATLog
import CocoaLumberjack

class FDEMessageViewController: FDEBaseViewController, MATLogDelegate {
    
     lazy var btn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 100, height: 44)
        btn.setTitle("button", for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(btnDidClicked(_:)), for: .touchUpInside)
        return btn
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSubview()
        
        MATLog.setDelegate(self)
    }

    func setupSubview() {
        self.navigationItem.title = "消息"
        view.addSubview(btn)
        btn.center = self.view.center
    }
    
    func uploadLogs(_ logs: [MATLogModel], completion completionBlock: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
            completionBlock(nil)
        })
    }

    @objc func btnDidClicked(_ sender: UIButton) {
        DLog("btnDidClicked")
        
        self.testMATLogUpload()
    }

    private func testDDLogAndMATLog() {
//        DDLogWrapper.logError("DDLog默认打印格式")
        MATLogDebug("MATLog默认打印格式")
    }

    private func testMATLogUpload() {
        for i in 0..<200 {
            MATLogDebug("the world of the war--\(i)", asynchronous: true, isUpload: true, moduleType: 1)
        }
    }
}

