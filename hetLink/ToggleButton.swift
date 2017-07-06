//
//  ToggleButton.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/6/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit

class ToggleButton: UIButton {
    
    var color: UIColor!
    
    convenience init(title: String, color: UIColor){
        self.init()
        self.color = color
        self.isSelected = true
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setTitleColor(.light, for: .selected)
        layer.cornerRadius = 5
        sizeToFit()
        
        self.addTarget(self, action: #selector(toggleSelected), for: .touchUpInside)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.backgroundColor = color.cgColor
            } else {
                layer.backgroundColor = UIColor.clear.cgColor
            }
        }
    }
    
    func toggleSelected(){
        self.isSelected = !self.isSelected
    }
}
