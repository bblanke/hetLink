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
    
    // Datasets
    var ecgOneDataSet: LineChartDataSet!
    var ecgTwoDataSet: LineChartDataSet!
    var ecgThreeDataSet: LineChartDataSet!
    
    var waveOneDataSet: LineChartDataSet!
    var waveTwoDataSet: LineChartDataSet!
    var waveThreeDataSet: LineChartDataSet!
    
    var chartData: ChartData!
    var chartDataSets: [LineChartDataSet]!
    
    let chartColors: [UIColor] = Array(Theme.graphColors[0...5])
    
    let range: Int = 200
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initChart(){
        ecgOneDataSet = LineChartDataSet(values: [], label: "ECG 1")
        ecgTwoDataSet = LineChartDataSet(values: [], label: "ECG 2")
        ecgThreeDataSet = LineChartDataSet(values: [], label: "ECG 3")
        
        waveOneDataSet = LineChartDataSet(values: [], label: "W1")
        waveTwoDataSet = LineChartDataSet(values: [], label: "W2")
        waveThreeDataSet = LineChartDataSet(values: [], label: "W3")
        
        chartDataSets = [ecgOneDataSet, ecgTwoDataSet, ecgThreeDataSet, waveOneDataSet, waveTwoDataSet, waveThreeDataSet]
        
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
        guard let packet = packet as? HETChestPacket else {
            return
        }
        
        let ts = packet.timestamp.timeIntervalSince1970
        
        let ecgOneEntry = ChartDataEntry(x: ts, y: Double(packet.ecgOne))
        let ecgTwoEntry = ChartDataEntry(x: ts, y: Double(packet.ecgTwo))
        let ecgThreeEntry = ChartDataEntry(x: ts, y: Double(packet.ecgThree))
        
        let waveOneEntry = ChartDataEntry(x: ts, y: Double(packet.waveOne))
        let waveTwoEntry = ChartDataEntry(x: ts, y: Double(packet.waveTwo))
        let waveThreeEntry = ChartDataEntry(x: ts, y: Double(packet.waveThree))
        
        self.data?.addEntry(ecgOneEntry, dataSetIndex: 0)
        self.data?.addEntry(ecgTwoEntry, dataSetIndex: 1)
        self.data?.addEntry(ecgThreeEntry, dataSetIndex: 2)
        
        self.data?.addEntry(waveOneEntry, dataSetIndex: 3)
        self.data?.addEntry(waveTwoEntry, dataSetIndex: 4)
        self.data?.addEntry(waveThreeEntry, dataSetIndex: 5)
        
        let first = self.data?.dataSets[0].entryForIndex(0)
        
        self.xAxis.axisMinimum = (first?.x)!
        
        if (self.data?.dataSets[0].entryCount)! > self.range {
            _ = self.data?.dataSets[0].removeFirst()
            _ = self.data?.dataSets[1].removeFirst()
            _ = self.data?.dataSets[2].removeFirst()
            _ = self.data?.dataSets[3].removeFirst()
            _ = self.data?.dataSets[4].removeFirst()
            _ = self.data?.dataSets[5].removeFirst()
        }
        self.notifyDataSetChanged()
    }
    
    func graph(packets: [HETPacket]) {
        DispatchQueue.global(qos: .utility).async {
            for packet in packets {
                guard let packet = packet as? HETChestPacket else {
                    return
                }
                
                let ts = packet.timestamp.timeIntervalSince1970
                
                let ecgOneEntry = ChartDataEntry(x: ts, y: Double(packet.ecgOne))
                let ecgTwoEntry = ChartDataEntry(x: ts, y: Double(packet.ecgTwo))
                let ecgThreeEntry = ChartDataEntry(x: ts, y: Double(packet.ecgThree))
                
                let waveOneEntry = ChartDataEntry(x: ts, y: Double(packet.waveOne))
                let waveTwoEntry = ChartDataEntry(x: ts, y: Double(packet.waveTwo))
                let waveThreeEntry = ChartDataEntry(x: ts, y: Double(packet.waveThree))
                
                self.data?.addEntry(ecgOneEntry, dataSetIndex: 0)
                self.data?.addEntry(ecgTwoEntry, dataSetIndex: 1)
                self.data?.addEntry(ecgThreeEntry, dataSetIndex: 2)
                
                self.data?.addEntry(waveOneEntry, dataSetIndex: 3)
                self.data?.addEntry(waveTwoEntry, dataSetIndex: 4)
                self.data?.addEntry(waveThreeEntry, dataSetIndex: 5)
            }
            
            DispatchQueue.main.async {
                self.notifyDataSetChanged()
                self.setVisibleXRangeMaximum(8)
            }
        }
    }
    
    func setVisibility(_ visibility: Bool, dataset: LineChartDataSet) {
        dataset.visible = visibility
        notifyDataSetChanged()
    }
}
