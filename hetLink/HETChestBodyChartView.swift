//
//  HETChestBodyChartView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/20/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import Charts

class HETChestBodyChartView: ChartView, HETChartView {
    
    // Entries
    var ecgEntries: [ChartDataEntry] = []
    var waveOneEntries: [ChartDataEntry] = []
    var waveTwoEntries: [ChartDataEntry] = []
    var waveThreeEntries: [ChartDataEntry] = []
    var waveFourEntries: [ChartDataEntry] = []
    
    // Datasets
    var ecgDataSet: LineChartDataSet!
    var waveOneDataSet: LineChartDataSet!
    var waveTwoDataSet: LineChartDataSet!
    var waveThreeDataSet: LineChartDataSet!
    var waveFourDataSet: LineChartDataSet!
    
    var dataSets: [LineChartDataSet]!
    
    let chartColors: [UIColor] = [.chartOne, .chartTwo, .chartThree, .chartFour]
    
    let range: Int = 200
    
    override init(frame: CGRect){
        ecgDataSet = LineChartDataSet(values: ecgEntries, label: "ECG")
        waveOneDataSet = LineChartDataSet(values: waveOneEntries, label: "W1")
        waveTwoDataSet = LineChartDataSet(values: waveTwoEntries, label: "W2")
        waveThreeDataSet = LineChartDataSet(values: waveThreeEntries, label: "W3")
        waveFourDataSet = LineChartDataSet(values: waveFourEntries, label: "W4")
        
        dataSets = [ecgDataSet, waveOneDataSet, waveTwoDataSet, waveThreeDataSet, waveFourDataSet]
        
        for (index, set) in dataSets.enumerated() {
            set.drawCirclesEnabled = false
            set.cubicIntensity = 1.0
            set.drawValuesEnabled = false
            set.lineWidth = 2
            set.setColor(chartColors[index])
        }
        
        super.init(frame: frame)
        data = LineChartData(dataSets: dataSets)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func graph(packet: HETPacket) {
        let packet = packet as! HETChestBodyPacket
        
        print("graphing \(packet.ecg)")
    }
}
