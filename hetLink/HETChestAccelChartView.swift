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
    
    let chartColors: [UIColor] = Array(Theme.graphColors[5...7])
    
    let range: Int = 22
    
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
        
        let ts = packet.timestamp.timeIntervalSince1970
        
        let xEntry = ChartDataEntry(x: ts, y: Double(packet.x))
        let yEntry = ChartDataEntry(x: ts, y: Double(packet.y))
        let zEntry = ChartDataEntry(x: ts, y: Double(packet.z))
        
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
        
        self.notifyDataSetChanged()
    }
    
    func graph(packets: [HETPacket]) {
        let start = Date()
        DispatchQueue.global(qos: .utility).async {
            for packet in packets {
                guard let packet = packet as? HETBattAccelPacket else {
                    return
                }
                
                let ts = packet.timestamp.timeIntervalSince1970
                
                let xEntry = ChartDataEntry(x: ts, y: Double(packet.x))
                let yEntry = ChartDataEntry(x: ts, y: Double(packet.y))
                let zEntry = ChartDataEntry(x: ts, y: Double(packet.z))
                
                self.data?.addEntry(xEntry, dataSetIndex: 0)
                self.data?.addEntry(yEntry, dataSetIndex: 1)
                self.data?.addEntry(zEntry, dataSetIndex: 2)
                
            }
            print("Adding accel datasets took: \(Date().timeIntervalSince(start))")
            
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
