//
//  ActivityHomeViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/24.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import Firebase
import BTNavigationDropdownMenu
import SwipeCellKit

class ActivityHomeViewController: BaseDropMenuViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    var activities: [Activity] = []
    var showActivities: [Activity] = []
    private var dropMenuSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: Config.TableViewCell.Activity.home, bundle: nil), forCellReuseIdentifier: Config.TableViewCell.Activity.home)
        tableView.tableFooterView = UIView()
        
        self.setNavigationDropdownMenu()
        self.navigationItem.rightBarButtonItem = self.createNavigationBarButton(selector: #selector(refresh), image: UIImage(named: "ic_refresh"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    @objc func refresh() {
        self.getActivities()
    }
}

extension ActivityHomeViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.showActivities.remove(at: indexPath.row)
            action.fulfill(with: .delete)
            
            let ref = Database.database().reference().child(Config.Firebase.Activity.nodeName).child(self.activities[indexPath.row].activityID)
            
            FirebaseManager.shared.deleteData(ref: ref) {
                self.refresh()
            }
        }
        
        deleteAction.image = UIImage(named: "ic_delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = self.showActivities[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.TableViewCell.Activity.home, for: indexPath) as? ActivityHomeTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configCell(with: activity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showActivities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ref = Database.database().reference().child(Config.Firebase.Product.nodeName).child(self.activities[indexPath.row].productID)
        
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
extension ActivityHomeViewController {
    
    func getActivities() {
        
        let ref = Database.database().reference().child(Config.Firebase.Activity.nodeName)
        
        FirebaseManager.shared.getDataSnapshots(ref: ref) { (result) in
            switch result {

            case .success(let snaps):

                self.activities.removeAll()

                for snap in snaps {

                    let parser = ActivityParser()

                    guard
                        let activity = parser.parserActivity(snap)
                        else {
                            continue
                    }
                    self.activities.append(activity)
                }

                self.activities.sort { $0.time > $1.time }
                
                self.showActivities = self.selectedActivities(at: self.dropMenuSelectedIndex)
                
                self.tableView.reloadData()

            case .error(let error):

                self.showErrorAlert(error: error, myErrorMsg: nil)

            }
        }
    }
    
    func setNavigationDropdownMenu() {
        let menuView = BTNavigationDropdownMenu(title: "All", items: ["All"] + ActivityType.allRawValues)
        
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = { [weak self] (indexPath: Int) -> Void in
            
            self?.dropMenuSelectedIndex = indexPath
            
            self?.showActivities = self?.selectedActivities(at: indexPath) ?? []
            
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
    
    private func selectedActivities(at index: Int) -> [Activity] {
        var selectedActivities: [Activity] = []
        switch index {
        case 1:
            selectedActivities = self.activities.filter({
                $0.type == ActivityType.create
            })
        case 2:
            selectedActivities = self.activities.filter({
                $0.type == ActivityType.update
            })
        case 3:
            selectedActivities = self.activities.filter({
                $0.type == ActivityType.delete
            })
        default:
            selectedActivities = self.activities
        }
        return selectedActivities
    }
}
