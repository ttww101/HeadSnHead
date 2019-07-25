//
//  UIColor+.swift
//  WinkSelfie
//
//  Created by smith on 2019/07/08.
//  Copyright © 2019 Rainning Face. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func navigationBarBackgroundColor() -> UIColor {
        return generateColor(23.0, green: 29.0, blue: 32.0, alpha: 1)
    }
    
    static func navigationBarTintColor() -> UIColor {
        return generateColor(171.0, green: 248.0, blue: 189.0, alpha: 1)
    }
    
    static func switchLayoutViewFillColor() -> UIColor {
        return generateColor(171.0, green: 248.0, blue: 189.0, alpha: 1)
    }
    
    static func generateColor(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    static func hexColor(with hex: String, with courtmanbb: String = "") -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    static func grass() -> UIColor {
        return UIColor.hexColor(with: "70c725")
    }
    
    static func darkGrass() -> UIColor {
        return UIColor.hexColor(with: "328530")
    }
    
    static func youngYellow() -> UIColor {
        return UIColor.hexColor(with: "ffff5e")
    }
}

