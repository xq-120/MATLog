//
//  FDEMineViewController.swift
//  MATLogDemo
//
//  Created by xq on 2023/2/16.
//

import UIKit
import CocoaLumberjack

class FDEMineViewController: FDEBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSubview()
    }

    func setupSubview() {
        self.navigationItem.title = "我"
    }


}

