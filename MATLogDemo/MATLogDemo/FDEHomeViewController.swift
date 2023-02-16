//
//  ViewController.swift
//  DemonSwift
//
//  Created by xuequan on 2020/1/30.
//  Copyright © 2020 xuequan. All rights reserved.
//

import UIKit

class FDEHomeViewController: FDEBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView.init()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var dataList: [FDEItemModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubview()
        loadData()
    }
    
    func setupSubview() {
        self.navigationItem.title = "首页"
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }

    func loadData() {
        dataList.removeAll()
        
        let one = FDEItemModel.init()
        one.title = "situation 0 Title"
        one.actionBlk = { [weak self] in
            let detailVC = FDEDetailViewController.init()
            detailVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
        dataList.append(one)
        
        let two = FDEItemModel.init()
        two.title = "situation 1 Title"
        two.actionBlk = { [weak self] in
            let detailVC = FDEDetailViewController.init()
            detailVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
        dataList.append(two)
        
        let three = FDEItemModel.init()
        three.title = "situation 2 Title"
        three.actionBlk = { [weak self] in
            let detailVC = FDEDetailViewController.init()
            detailVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
        dataList.append(three)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item.title
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataList[indexPath.row]
        item.actionBlk?()
    }
}

