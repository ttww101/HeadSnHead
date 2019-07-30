//
//  ProductDetailViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/29.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

class ProductDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var product: Product? = nil {
        didSet {
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        }
        self.title = "Info"
        tableView.register(UINib(nibName: Config.TableViewCell.productDetail, bundle: nil), forCellReuseIdentifier: Config.TableViewCell.productDetail)
        tableView.tableFooterView = UIView()
        
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "ic_editinfo"), for: .normal)
        btn1.imageView?.contentMode = .scaleAspectFit
        btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn1.addTarget(self, action: #selector(editButtonDidTouchUpInside), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        self.navigationItem.rightBarButtonItem  = item1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func editButtonDidTouchUpInside() {
        guard let vc = self.createViewControllerFromStoryboard(name: Config.Storyboard.product, identifier: Config.Controller.productEdit) as? ProductEditViewController else { return }
        vc.type = .edit
        vc.product = self.product
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    // MARK: - Table view data source
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let product = product else { return UITableViewCell() }
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailTableViewCell", for: indexPath) as! ProductDetailTableViewCell
            cell.nameLabel.text = product.name
            cell.displayImageView.image = product.avatar
            cell.colorLabel.text = product.color
            cell.descriptionLabel.text = product.description
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
}
