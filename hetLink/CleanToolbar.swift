//
//  CleanToolbar.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/27/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit

class CleanToolbar: UIToolbar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("this is called")
        layer.backgroundColor = UIColor.primary.cgColor
        layer.borderWidth = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
