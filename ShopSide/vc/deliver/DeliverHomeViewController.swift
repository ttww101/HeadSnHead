//
//  DeliverHomeViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/8/12.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import Firebase
import BTNavigationDropdownMenu
import SnapKit

class DeliverHomeViewController: BaseDropMenuViewController {

    @IBOutlet weak var tableView: UITableView!
    var delivers: [Deliver] = []
    var showDelivers: [Deliver] = []
    private var dropMenuSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -10)
        //
        tableView.register(UINib(nibName: Config.TableViewCell.Deliver.home, bundle: nil), forCellReuseIdentifier: Config.TableViewCell.Deliver.home)
        
        self.getdelivers()
        self.setNavigationDropdownMenu()
        self.navigationItem.rightBarButtonItem = self.createNavigationBarButton(selector: #selector(refresh), image: UIImage(named: "ic_refresh"))
    }
    
    @objc func refresh() {
        self.getdelivers()
    }
}

extension DeliverHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView()
//        let heightview = UIView()
//        view.addSubview(heightview)
//        heightview.backgroundColor = .groupTableViewBackground
//        heightview.snp.makeConstraints { (make) in
//            make.edges.equalTo(view).inset(0)
//            make.height.equalTo(16)
//        }
//        return view
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deliver = self.showDelivers[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.TableViewCell.Deliver.home, for: indexPath) as? DeliverHomeTableViewCell else {
            return UITableViewCell()
        }
        cell.configCell(with: deliver)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showDelivers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        return
        
        let ref = Database.database().reference().child(Config.Firebase.Product.nodeName).child(self.delivers[indexPath.row].productID)
        
        FirebaseManager.shared.getDataSnapshot(ref: ref) { (result) in
            switch result {
                
            case .success(let snap):
                
                let parser = ProductParser()
                
                let product = parser.parserProduct(snap)
                
                guard let vc = self.createViewControllerFromStoryboard(name: Config.Storyboard.product, identifier: Config.Controller.Product.detail) as? ProductDetailViewController else { return }
                vc.product = product
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .error:
                self.showErrorAlert(error: nil, myErrorMsg: ErrorMessage.emptyProduct)
            }
        }
    }
}

//MARK: Private
extension DeliverHomeViewController {
    
    func getdelivers() {
        
        let ref = Database.database().reference().child(Config.Firebase.Delivers.nodeName)
        
        FirebaseManager.shared.getDataSnapshots(ref: ref) { (result) in
            switch result {
                
            case .success(let snaps):
                
                self.delivers.removeAll()
                
                for snap in snaps {
                    
                    let parser = DeliverParser()
                    
                    guard
                        let deliver = parser.parserDeliver(snap)
                        else {
                            continue
                    }
                    self.delivers.append(deliver)
                }
                
                self.delivers.sort { $0.state.rawValue > $1.state.rawValue }
                
                self.showDelivers = self.showDelivers(at: self.dropMenuSelectedIndex)
                
                self.tableView.reloadData()
                
            case .error(let error):
                
                self.showErrorAlert(error: error, myErrorMsg: nil)
                
            }
        }
    }
    
    func setNavigationDropdownMenu() {
        let menuView = BTNavigationDropdownMenu(title: "All", items: ["All"] + DeliverState.allRawValues)
        
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = { [weak self] (indexPath: Int) -> Void in
            
            self?.dropMenuSelectedIndex = indexPath
            
            self?.showDelivers = self?.showDelivers(at: indexPath) ?? []
            
            self?.tableView.reloadData()
        }
        
        menuView.menuTitleColor = .black
        menuView.arrowTintColor = .black
        menuView.selectedCellTextLabelColor = .gray
        menuView.cellTextLabelColor = .black
        menuView.cellSelectionColor = .groupTableViewBackground
        menuView.cellSeparatorColor = .gray
        menuView.cellBackgroundColor = .white
    }
    
    private func showDelivers(at index: Int) -> [Deliver] {
        var showDelivers: [Deliver] = []
        switch index {
        case 1:
            showDelivers = self.delivers.filter({
                $0.state == DeliverState.ordered
            })
        case 2:
            showDelivers = self.delivers.filter({
                $0.state == DeliverState.delivering
            })
        case 3:
            showDelivers = self.delivers.filter({
                $0.state == DeliverState.delivered
            })
        default:
            showDelivers = self.delivers
        }
        return showDelivers
    }
}
