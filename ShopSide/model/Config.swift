//
//  Config.swift
//  ShopSide
//
//  Created by Wu on 2019/7/25.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

struct Config {
    
    struct Menu {
        static let names = ["Product", "Activity", "Setting"]
    }
    
    struct Storyboard {
        static let main = "Main"
        static let product = "Product"
    }
    
    struct Controller {
        static let productTotal = "ProductTotalViewController"
        static let productDetail = "ProductDetailViewController"
        static let productEdit = "ProductEditViewController"
    }
    
    struct TableViewCell {
        static let productDetail = "ProductDetailTableViewCell"
        static let productEdit = "ProductEditTableViewCell"
    }
    
    struct Test {
        static let products: [Product] = [
            Product(name: "NIKE X SHOE DOG CORTEZ '72 QS", surname: "", avatar: UIImage(named: "1.jpg")!, availableCount: 20, color: "WHITE / VARSITY RED / GAME ROYAL", description: "This product is offered in men's sizing.\n\nThere is an approximate 1.5-size difference between men's and women's sizing.\n\nFor example, a women’s size 8.5 is roughly equivalent to a men’s size 7."),
            Product(name: "NIKE AIR JORDAN 1 LOW", surname: "", avatar: UIImage(named: "2.jpg")!, availableCount: 100, color: "ROYAL", description: "Air Jordan 1 Low silhouette / Leather upper /Perforated toe box / Padded collar / Jumpman logo on tongue"),
            Product(name: "ADIDAS YEEZY 700 V2", surname: "", avatar: UIImage(named: "3.jpg")!, availableCount: 100, color: "TEPHRA", description: "700 V2 silhouette / Mesh vamp  /Leather and suede overlays /Perforated heel  /Boost-infused  /rubber sole unit /Herringbone outsole"),
            Product(name: "VANS ERA 3RA VISION VOYAGE", surname: "", avatar: UIImage(named: "4.jpg")!, availableCount: 20, color: "BLACK / TRUE WHITE", description: "ERA 3RA Vision Voyage silhouette / Canvas upper / Dual-stitch detailing / Metal eyelets / Triple-layered tongue"),
            Product(name: "ADIDAS CONSORTIUM X PHARRELL WILLIAMS SOLAR HU PRO", surname: "", avatar: UIImage(named: "5.jpg")!, availableCount: 20, color: "WHITE / RAW WHITE / OFF WHITE", description: "Solar HU Pro silhouette / Primeknit upper / Neoprene eyestays / Rope laces / Suede overlays / TPU heel counter / Printed graphics on toe box / Thin rubber midsole / BOOST midsole / Rubber Continental outsole"),
            Product(name: "NIKE X SHOE DOG CORTEZ '72 QS", surname: "", avatar: UIImage(named: "1.jpg")!, availableCount: 20, color: "WHITE / VARSITY RED / GAME ROYAL", description: "This product is offered in men's sizing.\n\nThere is an approximate 1.5-size difference between men's and women's sizing.\n\nFor example, a women’s size 8.5 is roughly equivalent to a men’s size 7."),
            Product(name: "NIKE AIR JORDAN 1 LOW", surname: "", avatar: UIImage(named: "2.jpg")!, availableCount: 100, color: "ROYAL", description: "Air Jordan 1 Low silhouette / Leather upper /Perforated toe box / Padded collar / Jumpman logo on tongue"),
            Product(name: "ADIDAS YEEZY 700 V2", surname: "", avatar: UIImage(named: "3.jpg")!, availableCount: 100, color: "TEPHRA", description: "700 V2 silhouette / Mesh vamp  /Leather and suede overlays /Perforated heel  /Boost-infused  /rubber sole unit /Herringbone outsole"),
            Product(name: "VANS ERA 3RA VISION VOYAGE", surname: "", avatar: UIImage(named: "4.jpg")!, availableCount: 20, color: "BLACK / TRUE WHITE", description: "ERA 3RA Vision Voyage silhouette / Canvas upper / Dual-stitch detailing / Metal eyelets / Triple-layered tongue"),
            Product(name: "ADIDAS CONSORTIUM X PHARRELL WILLIAMS SOLAR HU PRO", surname: "", avatar: UIImage(named: "5.jpg")!, availableCount: 20, color: "WHITE / RAW WHITE / OFF WHITE", description: "Solar HU Pro silhouette / Primeknit upper / Neoprene eyestays / Rope laces / Suede overlays / TPU heel counter / Printed graphics on toe box / Thin rubber midsole / BOOST midsole / Rubber Continental outsole"),
        ]
    }
}
