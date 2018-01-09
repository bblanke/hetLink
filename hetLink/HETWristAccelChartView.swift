//
//  HETWristAccelChartView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 12/21/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import Charts

class HETWristAccelChartView: ChartView, HETChartView {
    
    // Entries
    var xEntries: [ChartDataEntry] = []
    var yEntries: [ChartDataEntry] = []
    var zEntries: [ChartDataEntry] = []
    
    // Datasets
    var xSet: LineChartDataSet!
    var ySet: LineChartDataSet!
    var zSet: LineChartDataSet!
    
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
        xSet = LineChartDataSet(values: xEntries, label: "x")
        ySet = LineChartDataSet(values: yEntries, label: "y")
        zSet = LineChartDataSet(values: zEntries, label: "z")
        
        chartDataSets = [xSet, ySet, zSet]
        
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
        
        let x = ChartDataEntry(x: ts, y: Double(packet.x))
        let y = ChartDataEntry(x: ts, y: Double(packet.y))
        let z = ChartDataEntry(x: ts, y: Double(packet.z))
        
        data?.addEntry(x, dataSetIndex: 0)
        data?.addEntry(y, dataSetIndex: 1)
        data?.addEntry(z, dataSetIndex: 2)
        
        
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
                
                let x = ChartDataEntry(x: ts, y: Double(packet.x))
                let y = ChartDataEntry(x: ts, y: Double(packet.y))
                let z = ChartDataEntry(x: ts, y: Double(packet.z))
                
                
                self.data?.addEntry(x, dataSetIndex: 0)
                self.data?.addEntry(y, dataSetIndex: 1)
                self.data?.addEntry(z, dataSetIndex: 2)
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

