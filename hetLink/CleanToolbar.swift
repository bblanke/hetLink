//
//  CleanToolbar.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/27/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit

class CleanToolbar: UIToolbar {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
        layer.borderWidth = 0
    }

}
