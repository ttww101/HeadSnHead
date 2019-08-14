//
//  Config.swift
//  ShopSide
//
//  Created by Wu on 2019/7/25.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

struct Config {
    
    static let AppAssociateName = "Shop_Side"
    
    struct Menu {
        static let names = ["Product", "Activity", "Deliver", "Setting", "Rate us"]
    }
    
    struct Storyboard {
        static let main = "Main"
        static let menu = "Menu"
        static let product = "Product"
        static let login = "Login"
        static let activity = "Activity"
        static let popup = "Popup"
        static let deliver = "Deliver"
        static let setting = "Setting"
    }
    
    struct Controller {
        
        struct Main {
            static let landing = "LandingViewController"
        }
        
        struct Login {
            static let login = "LoginViewController"
            static let register = "RegisterViewController"
        }
        
        struct Product {
            static let nav = "ProductNavigationController"
            static let detail = "ProductDetailViewController"
            static let edit = "ProductEditViewController"
        }
        
        struct Activity {
            static let nav = "ActivityNavigationController"
        }
        
        struct Deliver {
            static let nav = "DeliverNavigationController"
        }
        
        struct Setting {
            static let nav = "SettingNavigationController"
            static let profile = "ProfileViewController"
        }
        
        struct Popup {
            static let deliver = "DeliverPopViewController"
        }
    }
    
    struct TableViewCell {
        
        struct Product {
            static let detail = "ProductDetailTableViewCell"
            static let edit = "ProductEditTableViewCell"
        }
        
        struct Activity {
            static let home = "ActivityHomeTableViewCell"
        }
        
        struct Deliver {
            static let home = "DeliverHomeTableViewCell"
        }
    }
    
    struct Firebase {
        
        static let dbUrl = "https://fcustomer-404c0.firebaseio.com/"
        
        struct Storage {
            static let userPhoto = "UserPhoto"
            static let productPhoto = "ProductPhoto"
        }
        
        struct User {
            static let userID = "userID"
            static let nodeName = "Users"
            static let email = "Email"
            static let name = "Name"
            static let gender = "Gender"
            static let photoURL = "PhotoURL"
        }
        
        struct Product {
            static let nodeName = "Products_of_\(Config.AppAssociateName)"
            
            struct Keys {
                static let owner = "Owner"
                static let productID = "ProductID"
                static let name = "Name"
                static let surname = "Surname"
                static let photoURL = "PhotoURL"
                static let availableCount = "AvailableCount"
                static let color = "Color"
                static let description = "Description"
                static let price = "Price"
            }
        }
        
        struct Delivers {
            static let nodeName = "Delivers_of_\(Config.AppAssociateName)"
            struct Keys {
                static let state = "State"
                static let productID = "ProductID"
                static let address = "Address"
                static let orderCount = "OrderCount"
                static let createTime = "CreateTime"
            }
        }
        
        struct Activity {
            static let nodeName = "Activity_of_\(Config.AppAssociateName)"
            
            struct Keys {
                static let type = "Type"
                static let owner = "Owner"
                static let ownerPhotoURL = "Owner_PhotoURL"
                static let activityID = "AvtivityID"
                static let title = "Title"
                static let content = "Content"
                static let productID = "ProductID"
                static let productPhotoURL = "ProductPhotoURL"
                static let time = "Time"
            }
        }

    }
    
    struct Test {
//        static let products: [Product] = [
//            Product(name: "NIKE X SHOE DOG CORTEZ '72 QS", surname: "", avatar: UIImage(named: "1.jpg")!, availableCount: 20, color: "WHITE / VARSITY RED / GAME ROYAL", description: "This product is offered in men's sizing.\n\nThere is an approximate 1.5-size difference between men's and women's sizing.\n\nFor example, a women’s size 8.5 is roughly equivalent to a men’s size 7.", price: "100"),
//            Product(name: "NIKE AIR JORDAN 1 LOW", surname: "", avatar: UIImage(named: "2.jpg")!, availableCount: 100, color: "ROYAL", description: "Air Jordan 1 Low silhouette / Leather upper /Perforated toe box / Padded collar / Jumpman logo on tongue", price: "100"),
//            Product(name: "ADIDAS YEEZY 700 V2", surname: "", avatar: UIImage(named: "3.jpg")!, availableCount: 100, color: "TEPHRA", description: "700 V2 silhouette / Mesh vamp  /Leather and suede overlays /Perforated heel  /Boost-infused  /rubber sole unit /Herringbone outsole", price: "100"),
//            Product(name: "VANS ERA 3RA VISION VOYAGE", surname: "", avatar: UIImage(named: "4.jpg")!, availableCount: 20, color: "BLACK / TRUE WHITE", description: "ERA 3RA Vision Voyage silhouette / Canvas upper / Dual-stitch detailing / Metal eyelets / Triple-layered tongue", price: "100"),
//            Product(name: "ADIDAS CONSORTIUM X PHARRELL WILLIAMS SOLAR HU PRO", surname: "", avatar: UIImage(named: "5.jpg")!, availableCount: 20, color: "WHITE / RAW WHITE / OFF WHITE", description: "Solar HU Pro silhouette / Primeknit upper / Neoprene eyestays / Rope laces / Suede overlays / TPU heel counter / Printed graphics on toe box / Thin rubber midsole / BOOST midsole / Rubber Continental outsole", price: "100"),
//            Product(name: "NIKE X SHOE DOG CORTEZ '72 QS", surname: "", avatar: UIImage(named: "1.jpg")!, availableCount: 20, color: "WHITE / VARSITY RED / GAME ROYAL", description: "This product is offered in men's sizing.\n\nThere is an approximate 1.5-size difference between men's and women's sizing.\n\nFor example, a women’s size 8.5 is roughly equivalent to a men’s size 7.", price: "100"),
//            Product(name: "NIKE AIR JORDAN 1 LOW", surname: "", avatar: UIImage(named: "2.jpg")!, availableCount: 100, color: "ROYAL", description: "Air Jordan 1 Low silhouette / Leather upper /Perforated toe box / Padded collar / Jumpman logo on tongue", price: "100"),
//            Product(name: "ADIDAS YEEZY 700 V2", surname: "", avatar: UIImage(named: "3.jpg")!, availableCount: 100, color: "TEPHRA", description: "700 V2 silhouette / Mesh vamp  /Leather and suede overlays /Perforated heel  /Boost-infused  /rubber sole unit /Herringbone outsole", price: "100"),
//            Product(name: "VANS ERA 3RA VISION VOYAGE", surname: "", avatar: UIImage(named: "4.jpg")!, availableCount: 20, color: "BLACK / TRUE WHITE", description: "ERA 3RA Vision Voyage silhouette / Canvas upper / Dual-stitch detailing / Metal eyelets / Triple-layered tongue", price: "100"),
//            Product(name: "ADIDAS CONSORTIUM X PHARRELL WILLIAMS SOLAR HU PRO", surname: "", avatar: UIImage(named: "5.jpg")!, availableCount: 20, color: "WHITE / RAW WHITE / OFF WHITE", description: "Solar HU Pro silhouette / Primeknit upper / Neoprene eyestays / Rope laces / Suede overlays / TPU heel counter / Printed graphics on toe box / Thin rubber midsole / BOOST midsole / Rubber Continental outsole", price: "100"),
//        ]
    }
}
