//
//  SettingHomeViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/8/12.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import SnapKit

class SettingHomeViewController: BaseDropMenuViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var switchControl: UISwitch = UISwitch()
    var titles = ["Foreground notification", "Go iPhone Settings"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.switchControl.addTarget(self, action: #selector(switchDidChanged(_:)), for: .valueChanged)
    }
    
    @objc func switchDidChanged(_ sender: UISwitch) {
        if sender.isOn {
            
        } else {
            
        }
    }
    
}

extension SettingHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 1) {
            let urlstr = UIApplication.openSettingsURLString
            guard let url = URL(string: urlstr) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "settingcell"
        var cell = tableView.dequeueReusableCell(withIdentifier:identifier)
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            if indexPath.row == 0 {
                cell!.contentView.addSubview(self.switchControl)
                cell!.selectionStyle = .none
                self.switchControl.snp.makeConstraints { (make) in
                    make.top.equalTo(cell!.contentView).inset(8)
                    make.bottom.equalTo(cell!.contentView).inset(8)
                    make.trailing.equalTo(cell!.contentView).inset(16)
                }
            } else if indexPath.row == 1 {
                cell?.accessoryType = .disclosureIndicator
            }
        }
        cell?.textLabel?.text = titles[indexPath.row]
        return cell ?? UITableViewCell()
    }
}
