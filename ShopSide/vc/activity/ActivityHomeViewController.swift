//
//  ActivityHomeViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/24.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import Firebase

class ActivityHomeViewController: BaseDropMenuViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    var activities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: Config.TableViewCell.Activity.home, bundle: nil), forCellReuseIdentifier: Config.TableViewCell.Activity.home)
        tableView.tableFooterView = UIView()
        
        self.getActivities()
    }
    
}

extension ActivityHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = self.activities[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.TableViewCell.Activity.home, for: indexPath) as? ActivityHomeTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = activity.title
        cell.contentLabel.text = activity.content
        cell.ownerNameLabel.text = activity.owner
        cell.timeLabel.text = activity.time
        cell.productImage = activity.productImage
        activity.didDownloadFinishedProductImage = { image in
            cell.productImage = image
        }
        cell.ownerImage = activity.ownerImage
        activity.didDownloadFinishedOwnerImage = { image in
            cell.ownerImage = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.createViewControllerFromStoryboard(name: Config.Storyboard.product, identifier: Config.Controller.Product.detail)as? ProductDetailViewController else { return }
//        vc.product = self.activities[indexPath.row].productID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Data
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
                
                self.tableView.reloadData()

            case .error(let error):

                self.showErrorAlert(error: error, myErrorMsg: nil)

            }
        }
    }
}
