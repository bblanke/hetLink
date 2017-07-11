//
//  SourceItemCell.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/11/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import ChameleonFramework

class SourceBrowserCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let textColor = ContrastColorOf(Theme.sourceBrowserCellBackground, returnFlat: true)
        
        self.backgroundColor = Theme.sourceBrowserCellBackground
        
        selectionStyle = .none
        
        titleLabel.textColor = textColor
        detailTextLabel?.textColor = textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.backgroundColor = selected ? Theme.sourceBrowserCellBackgroundActive : Theme.sourceBrowserCellBackground
    }

}
