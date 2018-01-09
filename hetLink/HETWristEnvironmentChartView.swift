//
//  HETWristEnvironmentChartView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 12/21/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import Charts

class HETWristEnvironmentChartView: ChartView, HETChartView {
    
    // Entries
    var tempEntries: [ChartDataEntry] = []
    var humidityEntries: [ChartDataEntry] = []
    
    // Datasets
    var tempSet: LineChartDataSet!
    var humiditySet: LineChartDataSet!
    
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
        tempSet = LineChartDataSet(values: tempEntries, label: "Temp")
        humiditySet = LineChartDataSet(values: humidityEntries, label: "Humidity")
        
        chartDataSets = [tempSet, humiditySet]
        
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
        
        let temp = ChartDataEntry(x: ts, y: Double(packet.temp))
        let humidity = ChartDataEntry(x: ts, y: Double(packet.humidity))
        
        
        data?.addEntry(temp, dataSetIndex: 0)
        data?.addEntry(humidity, dataSetIndex: 1)
        
        
        let first = data?.dataSets[0].entryForIndex(0)
        
        xAxis.axisMinimum = (first?.x)!
        
        if (data?.dataSets[0].entryCount)! > range {
            _ = data?.dataSets[0].removeFirst()
            _ = data?.dataSets[1].removeFirst()
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
                
                let temp = ChartDataEntry(x: ts, y: Double(packet.temp))
                let humidity = ChartDataEntry(x: ts, y: Double(packet.humidity))
                
                self.data?.addEntry(temp, dataSetIndex: 0)
                self.data?.addEntry(humidity, dataSetIndex: 1)
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

