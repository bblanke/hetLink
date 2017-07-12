//
//  ToggleBarButtonItem.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/12/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import ChameleonFramework

class ToggleBarButtonItem: UIBarButtonItem {
    var isSelected = false
    var selectedColor: UIColor = UIColor.flatRed
    var deselectedColor: UIColor = UIColor.flatWhite
    
    func toggleSelected() {
        isSelected = !isSelected
        tintColor = isSelected ? selectedColor : deselectedColor
    }
}
