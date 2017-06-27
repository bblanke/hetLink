//
//  ChartView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/15/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import Charts

class ChartView: LineChartView {
    
    weak var axisFormatDelegate : IAxisValueFormatter?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axisFormatDelegate = self
        
        xAxis.valueFormatter = axisFormatDelegate
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.labelTextColor = .primary
        
        rightAxis.enabled = false
        rightAxis.drawGridLinesEnabled = false
        
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.labelTextColor = .primary
        leftAxis.drawGridLinesEnabled = false
        
        chartDescription?.enabled = false
        drawBordersEnabled = false
        
        noDataText = "No device or recording selected"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ChartView : IAxisValueFormatter{
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss.SS"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
