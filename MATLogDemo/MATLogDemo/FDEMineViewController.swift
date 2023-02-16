//
//  FDEMineViewController.swift
//  MATLogDemo
//
//  Created by xq on 2023/2/16.
//

import UIKit
import MATLog
import CocoaLumberjack

class FDEMineViewController: FDEBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSubview()
        
//        MATLogWrapper.logError("试试看东方闪电")
        
        DDLogDebug("CocoaLumberjack - swift")
    }

    func setupSubview() {
        self.navigationItem.title = "我"
    }


}

