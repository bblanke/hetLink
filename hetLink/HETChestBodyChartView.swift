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
    var ecgDataSet: LineChartDataSet!
    var waveOneDataSet: LineChartDataSet!
    var waveTwoDataSet: LineChartDataSet!
    var waveThreeDataSet: LineChartDataSet!
    var waveFourDataSet: LineChartDataSet!
    
    var chartData: ChartData!
    var chartDataSets: [LineChartDataSet]!
    
    let chartColors: [UIColor] = Array(Theme.graphColors[0...4])
    
    let range: Int = 200
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initChart(){
        ecgDataSet = LineChartDataSet(values: [], label: "ECG")
        waveOneDataSet = LineChartDataSet(values: [], label: "W1")
        waveTwoDataSet = LineChartDataSet(values: [], label: "W2")
        waveThreeDataSet = LineChartDataSet(values: [], label: "W3")
        waveFourDataSet = LineChartDataSet(values: [], label: "W4")
        
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
        
        let ts = packet.timestamp.timeIntervalSince1970
        
        let ecgEntry = ChartDataEntry(x: ts, y: Double(packet.ecg))
        let waveOneEntry = ChartDataEntry(x: ts, y: Double(packet.waveOne))
        let waveTwoEntry = ChartDataEntry(x: ts, y: Double(packet.waveTwo))
        let waveThreeEntry = ChartDataEntry(x: ts, y: Double(packet.waveThree))
        let waveFourEntry = ChartDataEntry(x: ts, y: Double(packet.waveFour))
        
        self.data?.addEntry(ecgEntry, dataSetIndex: 0)
        self.data?.addEntry(waveOneEntry, dataSetIndex: 1)
        self.data?.addEntry(waveTwoEntry, dataSetIndex: 2)
        self.data?.addEntry(waveThreeEntry, dataSetIndex: 3)
        self.data?.addEntry(waveFourEntry, dataSetIndex: 4)
        
        let first = self.data?.dataSets[0].entryForIndex(0)
        
        self.xAxis.axisMinimum = (first?.x)!
        
        if (self.data?.dataSets[0].entryCount)! > self.range {
            _ = self.data?.dataSets[0].removeFirst()
            _ = self.data?.dataSets[1].removeFirst()
            _ = self.data?.dataSets[2].removeFirst()
            _ = self.data?.dataSets[3].removeFirst()
            _ = self.data?.dataSets[4].removeFirst()
        }
        self.notifyDataSetChanged()
    }
    
    func graph(packets: [HETPacket]) {
        let start = Date()
        DispatchQueue.global(qos: .utility).async {
            for packet in packets {
                guard let packet = packet as? HETEcgPulseOxPacket else {
                    return
                }
                
                let ts = packet.timestamp.timeIntervalSince1970
                
                let ecgEntry = ChartDataEntry(x: ts, y: Double(packet.ecg))
                let waveOneEntry = ChartDataEntry(x: ts, y: Double(packet.waveOne))
                let waveTwoEntry = ChartDataEntry(x: ts, y: Double(packet.waveTwo))
                let waveThreeEntry = ChartDataEntry(x: ts, y: Double(packet.waveThree))
                let waveFourEntry = ChartDataEntry(x: ts, y: Double(packet.waveFour))
                
                self.data?.addEntry(ecgEntry, dataSetIndex: 0)
                self.data?.addEntry(waveOneEntry, dataSetIndex: 1)
                self.data?.addEntry(waveTwoEntry, dataSetIndex: 2)
                self.data?.addEntry(waveThreeEntry, dataSetIndex: 3)
                self.data?.addEntry(waveFourEntry, dataSetIndex: 4)
            }
            
            print("Adding packets to Pulse Ox Dataset Took: \(Date().timeIntervalSince(start))")
            
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
