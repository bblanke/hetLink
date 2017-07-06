//
//  CleanTableView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/28/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit

class CleanTableView: UITableView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //clipsToBounds = true
        
        contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

}
