//
//  CleanTableViewCell.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/28/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit

class CleanTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.light
        textLabel?.textColor = UIColor.dark
        
        selectionStyle = .none
        
        alpha = 0
        
        let transform = CATransform3DTranslate(CATransform3DIdentity, -20, 0, 0)
        layer.transform = transform
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
            self.layer.transform = CATransform3DIdentity
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            textLabel?.textColor = UIColor.primary
        } else {
            backgroundColor = UIColor.light
        }
    }

    override func display(_ layer: CALayer) {
        print("displaying")
    }
}
