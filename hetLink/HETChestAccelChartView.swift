//
//  HETChestAccelChartView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/28/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import Charts

class HETChestAccelChartView: ChartView, HETChartView {
    
    // Entries
    var xEntries: [ChartDataEntry] = []
    var yEntries: [ChartDataEntry] = []
    var zEntries: [ChartDataEntry] = []
    
    // Datasets
    var xDataSet: LineChartDataSet!
    var yDataSet: LineChartDataSet!
    var zDataSet: LineChartDataSet!
    
    var chartData: ChartData!
    var chartDataSets: [LineChartDataSet]!
    
    let chartColors: [UIColor] = [.chartOne, .chartTwo, .chartThree]
    
    let range: Int = 44
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initChart(){
        xDataSet = LineChartDataSet(values: xEntries, label: "X")
        yDataSet = LineChartDataSet(values: yEntries, label: "Y")
        zDataSet = LineChartDataSet(values: zEntries, label: "Z")
        
        chartDataSets = [xDataSet, yDataSet, zDataSet]
        
        for (index, set) in chartDataSets.enumerated() {
            set.drawCirclesEnabled = false
            set.cubicIntensity = 0.2
            set.mode = .horizontalBezier
            set.drawValuesEnabled = false
            set.lineWidth = 2
            set.setColor(chartColors[index])
        }
        
        chartData = LineChartData(dataSets: chartDataSets)
        data = chartData
        
        xAxis.resetCustomAxisMin()
    }
    
    func graph(packet: HETPacket) {
        guard let packet = packet as? HETBattAccelPacket else {
            return
        }
        
        let xEntry = ChartDataEntry(x: packet.timestamp, y: Double(packet.x))
        let yEntry = ChartDataEntry(x: packet.timestamp, y: Double(packet.y))
        let zEntry = ChartDataEntry(x: packet.timestamp, y: Double(packet.z))
        
        data?.addEntry(xEntry, dataSetIndex: 0)
        data?.addEntry(yEntry, dataSetIndex: 1)
        data?.addEntry(zEntry, dataSetIndex: 2)
        
        let first = data?.dataSets[0].entryForIndex(0)
        
        xAxis.axisMinimum = (first?.x)!
        
        if (data?.dataSets[0].entryCount)! > range {
            _ = data?.dataSets[0].removeFirst()
            _ = data?.dataSets[1].removeFirst()
            _ = data?.dataSets[2].removeFirst()
        }
        
        notifyDataSetChanged()
    }
    
    func toggleDataset(dataset: LineChartDataSet) {
        dataset.visible = !dataset.isVisible
        notifyDataSetChanged()
    }
}
