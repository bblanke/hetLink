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
    
    var chartData: ChartData!
    var chartDataSets: [LineChartDataSet]!
    
    let chartColors: [UIColor] = [.chartOne, .chartTwo, .chartThree, .chartFour, .chartFive]
    
    let range: Int = 400
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initChart(){
        ecgDataSet = LineChartDataSet(values: ecgEntries, label: "ECG")
        waveOneDataSet = LineChartDataSet(values: waveOneEntries, label: "W1")
        waveTwoDataSet = LineChartDataSet(values: waveTwoEntries, label: "W2")
        waveThreeDataSet = LineChartDataSet(values: waveThreeEntries, label: "W3")
        waveFourDataSet = LineChartDataSet(values: waveFourEntries, label: "W4")
        
        chartDataSets = [ecgDataSet, waveOneDataSet, waveTwoDataSet, waveThreeDataSet, waveFourDataSet]
        
        for (index, set) in chartDataSets.enumerated() {
            set.drawCirclesEnabled = false
            set.drawValuesEnabled = false
            set.lineWidth = 2
            set.setColor(chartColors[index])
        }
        
        chartData = LineChartData(dataSets: chartDataSets)
        data = chartData
        
        xAxis.resetCustomAxisMin()
    }
    
    func graph(packet: HETPacket) {
        guard let packet = packet as? HETEcgPulseOxPacket else {
            return
        }
        
        let ecgEntry = ChartDataEntry(x: packet.timestamp, y: Double(packet.ecg))
        let waveOneEntry = ChartDataEntry(x: packet.timestamp, y: Double(packet.waveOne))
        let waveTwoEntry = ChartDataEntry(x: packet.timestamp, y: Double(packet.waveTwo))
        let waveThreeEntry = ChartDataEntry(x: packet.timestamp, y: Double(packet.waveThree))
        let waveFourEntry = ChartDataEntry(x: packet.timestamp, y: Double(packet.waveFour))
        
        data?.addEntry(ecgEntry, dataSetIndex: 0)
        data?.addEntry(waveOneEntry, dataSetIndex: 1)
        data?.addEntry(waveTwoEntry, dataSetIndex: 2)
        data?.addEntry(waveThreeEntry, dataSetIndex: 3)
        data?.addEntry(waveFourEntry, dataSetIndex: 4)
        
        let first = data?.dataSets[0].entryForIndex(0)
        
        xAxis.axisMinimum = (first?.x)!

        if (data?.dataSets[0].entryCount)! > range {
            _ = data?.dataSets[0].removeFirst()
            _ = data?.dataSets[1].removeFirst()
            _ = data?.dataSets[2].removeFirst()
            _ = data?.dataSets[3].removeFirst()
            _ = data?.dataSets[4].removeFirst()
        }
        
        notifyDataSetChanged()
    }
    
    func toggleDataset(dataset: LineChartDataSet) {
        dataset.visible = !dataset.isVisible
        notifyDataSetChanged()
    }
}
