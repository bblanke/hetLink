//
//  DatasetToggleViewCell.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/11/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import Charts

class DatasetToggleViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    var dataset: LineChartDataSet!
    var charts: [HETChartView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    @IBAction func didToggleSwitch(_ sender: UISwitch) {
        guard dataset != nil else { return }
        for chart in charts {
            chart.setVisibility(sender.isOn, dataset: dataset)
        }
    }
}
