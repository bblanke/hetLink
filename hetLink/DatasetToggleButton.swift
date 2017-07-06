//
//  ToggleButton.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/27/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import Charts

class DatasetToggleButton: ToggleButton {
    
    var dataset: LineChartDataSet!
    var chart: HETChartView!
    
    convenience init(title: String, color: UIColor, dataset: LineChartDataSet, chart: HETChartView){
        self.init(title: title, color: color)
        self.dataset = dataset
        self.chart = chart
        self.addTarget(self, action: #selector(toggleDataset), for: .touchUpInside)
    }
    
    func toggleDataset(){
        chart.setVisibility(self.isSelected, dataset: dataset)
    }
}
