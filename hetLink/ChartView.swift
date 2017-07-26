//
//  ChartView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/15/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import Charts
import ChameleonFramework

class ChartView: LineChartView {
    
    weak var axisFormatDelegate : IAxisValueFormatter?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let textColor = ContrastColorOf(Theme.graphViewBackground, returnFlat: true)
        
        axisFormatDelegate = self
        
        xAxis.valueFormatter = axisFormatDelegate
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.labelTextColor = textColor
        
        rightAxis.enabled = false
        rightAxis.drawGridLinesEnabled = false
        
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.labelTextColor = textColor
        leftAxis.drawGridLinesEnabled = false
        
        chartDescription?.enabled = false
        drawBordersEnabled = false
        
        legend.enabled = false
        
        highlightPerDragEnabled = false
        highlightPerTapEnabled = false
        
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

protocol HETChartView: class {
    var chartDataSets: [LineChartDataSet]! { get }
    
    func graph(packet: HETPacket)
    func graph(packets: [HETPacket])
    func setVisibility(_ visibility: Bool, dataset: LineChartDataSet)
}

protocol ChartViewDelegate: class {
    func chartView(didToggle recording: Bool)
    func chartViewDidRequestExport()
}
