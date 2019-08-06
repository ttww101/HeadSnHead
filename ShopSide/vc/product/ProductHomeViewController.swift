//
//  ProductHomeViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/25.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import DisplaySwitcher
import SnapKit
import Firebase

private let animationDuration: TimeInterval = 0.3

private let listLayoutStaticCellHeight: CGFloat = 100
private let gridLayoutStaticCellHeight: CGFloat = 220

class ProductHomeViewController: BaseDropMenuViewController {

    let loadingIndicator = LoadingIndicator()
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var rotationButton: SwitchLayoutButton!
    
    fileprivate var tap: UITapGestureRecognizer!
    
    fileprivate var products: [Product] = []
    fileprivate var searchProducts: [Product] = []
    
    fileprivate var isTransitionAvailable = true
    fileprivate lazy var listLayout = DisplaySwitchLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .list)
    fileprivate lazy var gridLayout = DisplaySwitchLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .grid)
    fileprivate var layoutState: LayoutState = .list
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        searchProducts = products
        rotationButton.isSelected = true
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProducts()
    }
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: AnyObject) {
        if !isTransitionAvailable {
            return
        }
        let transitionManager: TransitionManager
        if layoutState == .list {
            layoutState = .grid
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: gridLayout, layoutState: layoutState)
        } else {
            layoutState = .list
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: listLayout, layoutState: layoutState)
        }
        transitionManager.startInteractiveTransition()
        rotationButton.isSelected = layoutState == .list
        rotationButton.animationDuration = animationDuration
    }
    
    @IBAction func addButtonDidTouchUpInside(_ sender: Any) {
        self.view.endEditing(true)
        guard let vc = self.createViewControllerFromStoryboard(name: Config.Storyboard.product, identifier: Config.Controller.Product.edit) as? ProductEditViewController else { return }
        vc.type = .add
        vc.product = Product(name: "", surname: "", avatar: nil, photoURL: "", availableCount: 0, color: "", description: "", price: "0")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Private
extension ProductHomeViewController {
    
    func getProducts() {
        
        let ref = Database.database().reference().child(Config.Firebase.Product.nodeName)
        
        self.loadingIndicator.start()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                self.loadingIndicator.stop()
                
                self.products.removeAll()
                
                guard
                    let snaps = snapshot.children.allObjects as? [DataSnapshot]
                else
                    { return }
                    
                for snap in snaps {
                    
                    let productParser = ProductParser()
                    
                    guard
                        let product = productParser.parserProduct(snap)
                        else {
                            continue
                    }
                    self.products.append(product)
                }
                
//                    self.gamesList.sort { $0.time < $1.time }
                self.searchProducts = self.products
                self.collectionView.reloadData()
                
            } else {
                print("=== Firebase products snapshot does not exist")
                self.loadingIndicator.stop()
            }
        })
    }
    
    fileprivate func setupCollectionView() {
        collectionView.collectionViewLayout = listLayout
        collectionView.register(ProductCollectionViewCell.cellNib, forCellWithReuseIdentifier:ProductCollectionViewCell.id)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ProductHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as! ProductCollectionViewCell
        if layoutState == .grid {
            cell.setupGridLayoutConstraints(1, cellWidth: cell.frame.width)
        } else {
            cell.setupListLayoutConstraints(1, cellWidth: cell.frame.width)
        }
        cell.bind(searchProducts[(indexPath as NSIndexPath).row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = self.createViewControllerFromStoryboard(name: Config.Storyboard.product, identifier: Config.Controller.Product.detail)as? ProductDetailViewController else { return }
        vc.product = searchProducts[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTransitionAvailable = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isTransitionAvailable = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}

//MARK: UISearchBarDelegate
extension ProductHomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchProducts = products
        } else {
            searchProducts = searchProducts.filter { return $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAtIndexPath indexPath: IndexPath) {
        print("Hi \((indexPath as NSIndexPath).row)")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tap)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

