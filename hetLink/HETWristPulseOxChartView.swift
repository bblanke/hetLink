//
//  HETWristEnvironmentChartView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 12/20/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import Charts

class HETWristPulseOxChartView: ChartView, HETChartView {
    
    // Entries
    var waveOneEntries: [ChartDataEntry] = []
    var waveTwoEntries: [ChartDataEntry] = []
    var waveThreeEntries: [ChartDataEntry] = []
    
    // Datasets
    var waveOneSet: LineChartDataSet!
    var waveTwoSet: LineChartDataSet!
    var waveThreeSet: LineChartDataSet!
    
    var chartData: ChartData!
    var chartDataSets: [LineChartDataSet]!
    
    let chartColors: [UIColor] = Array(Theme.graphColors[0...7])
    
    let range: Int = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initChart(){
        waveOneSet = LineChartDataSet(values: waveOneEntries, label: "W1")
        waveTwoSet = LineChartDataSet(values: waveTwoEntries, label: "W2")
        waveThreeSet = LineChartDataSet(values: waveThreeEntries, label: "W3")
        
        chartDataSets = [waveOneSet, waveTwoSet, waveThreeSet]
        
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
        guard let packet = packet as? HETWristEnvironmentECG else {
            return
        }
        
        let ts = packet.timestamp.timeIntervalSince1970
        
        let waveOne = ChartDataEntry(x: ts, y: Double(packet.waveOne))
        let waveTwo = ChartDataEntry(x: ts, y: Double(packet.waveTwo))
        let waveThree = ChartDataEntry(x: ts, y: Double(packet.waveThree))
        
        
        data?.addEntry(waveOne, dataSetIndex: 0)
        data?.addEntry(waveTwo, dataSetIndex: 1)
        data?.addEntry(waveThree, dataSetIndex: 2)
        
        
        let first = data?.dataSets[0].entryForIndex(0)
        
        xAxis.axisMinimum = (first?.x)!
        
        if (data?.dataSets[0].entryCount)! > range {
            _ = data?.dataSets[0].removeFirst()
            _ = data?.dataSets[1].removeFirst()
            _ = data?.dataSets[2].removeFirst()
        }
        
        self.notifyDataSetChanged()
    }
    
    func graph(packets: [HETPacket]) {
        DispatchQueue.global(qos: .utility).async {
            for packet in packets {
                guard let packet = packet as? HETWristEnvironmentECG else {
                    return
                }
                
                let ts = packet.timestamp.timeIntervalSince1970
                
                let waveOne = ChartDataEntry(x: ts, y: Double(packet.waveOne))
                let waveTwo = ChartDataEntry(x: ts, y: Double(packet.waveTwo))
                let waveThree = ChartDataEntry(x: ts, y: Double(packet.waveThree))
                
                
                self.data?.addEntry(waveOne, dataSetIndex: 0)
                self.data?.addEntry(waveTwo, dataSetIndex: 1)
                self.data?.addEntry(waveThree, dataSetIndex: 2)
            }
            
            DispatchQueue.main.async {
                self.notifyDataSetChanged()
                self.setVisibleXRangeMaximum(8)
            }
        }
    }
    
    func setVisibility(_ visibility: Bool, dataset: LineChartDataSet){
        dataset.visible = visibility
        notifyDataSetChanged()
    }
}
