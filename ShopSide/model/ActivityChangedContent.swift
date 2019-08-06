//
//  ActivityChangedContent.swift
//  ShopSide
//
//  Created by Wu on 2019/8/6.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import Foundation

class ActivityChangedContent {
    var isName = false
    var isCount = false
    var isColor = false
    var isPrice = false
    var isPhoto = false
    var isDescription = false
    
    func createString() -> String {
        var str = ""
        str.append(isName ? "- name\n" : "")
        str.append(isCount ? "- count\n" : "")
        str.append(isColor ? "- color\n" : "")
        str.append(isPrice ? "- price\n" : "")
        str.append(isPhoto ? "- photo\n" : "")
        str.append(isDescription ? "- description\n" : "")
        return str
    }
}
