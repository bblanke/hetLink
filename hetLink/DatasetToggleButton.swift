//
//  ToggleButton.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/27/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import Charts

class DatasetToggleButton: UIButton {
    
    var color: UIColor!
    var dataset: LineChartDataSet!
    var chart: HETChartView!
    
    convenience init(title: String, color: UIColor, dataset: LineChartDataSet, chart: HETChartView){
        self.init()
        self.color = color
        self.dataset = dataset
        self.chart = chart
        self.isSelected = true
        self.addTarget(self, action: #selector(toggleDataset), for: .touchUpInside)
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setTitleColor(.light, for: .selected)
        layer.cornerRadius = 5
        sizeToFit()
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
    
    func toggleDataset(){
        chart.toggleDataset(dataset: dataset)
        self.isSelected = self.dataset.isVisible
    }
}
