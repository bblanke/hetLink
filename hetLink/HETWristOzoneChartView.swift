//
//  HETWristOzoneChartView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 12/20/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import Charts

class HETWristOzoneChartView: ChartView, HETChartView {
    
    // Entries
    var batteryEntries: [ChartDataEntry] = []
    var ozoneOneEntries: [ChartDataEntry] = []
    var ozoneTwoEntries: [ChartDataEntry] = []
    var ozoneThreeEntries: [ChartDataEntry] = []
    var ozoneFourEntries: [ChartDataEntry] = []
    
    // Datasets
    var batterySet: LineChartDataSet!
    var ozoneOneSet: LineChartDataSet!
    var ozoneTwoSet: LineChartDataSet!
    var ozoneThreeSet: LineChartDataSet!
    var ozoneFourSet: LineChartDataSet!
    
    var chartData: ChartData!
    var chartDataSets: [LineChartDataSet]!
    
    let chartColors: [UIColor] = Array(Theme.graphColors[0...4])
    
    let range: Int = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initChart(){
        batterySet = LineChartDataSet(values: batteryEntries, label: "Battery")
        ozoneOneSet = LineChartDataSet(values: ozoneOneEntries, label: "Oz 1")
        ozoneTwoSet = LineChartDataSet(values: ozoneTwoEntries, label: "Oz 2")
        ozoneThreeSet = LineChartDataSet(values: ozoneThreeEntries, label: "Oz 3")
        ozoneFourSet = LineChartDataSet(values: ozoneFourEntries, label: "Oz 4")
        
        chartDataSets = [batterySet, ozoneOneSet, ozoneTwoSet, ozoneThreeSet, ozoneFourSet]
        
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
        guard let packet = packet as? HETWristOzonePacket else {
            return
        }
        
        let ts = packet.timestamp.timeIntervalSince1970
        
        let battery = ChartDataEntry(x: ts, y: Double(packet.battery))
        let ozoneOne = ChartDataEntry(x: ts, y: Double(packet.ozoneOne))
        let ozoneTwo = ChartDataEntry(x: ts, y: Double(packet.ozoneTwo))
        let ozoneThree = ChartDataEntry(x: ts, y: Double(packet.ozoneThree))
        let ozoneFour = ChartDataEntry(x: ts, y: Double(packet.ozoneFour))
        
        
        data?.addEntry(battery, dataSetIndex: 0)
        data?.addEntry(ozoneOne, dataSetIndex: 1)
        data?.addEntry(ozoneTwo, dataSetIndex: 2)
        data?.addEntry(ozoneThree, dataSetIndex: 3)
        data?.addEntry(ozoneFour, dataSetIndex: 4)
        
        
        let first = data?.dataSets[0].entryForIndex(0)
        
        xAxis.axisMinimum = (first?.x)!
        
        if (data?.dataSets[0].entryCount)! > range {
            _ = data?.dataSets[0].removeFirst()
            _ = data?.dataSets[1].removeFirst()
            _ = data?.dataSets[2].removeFirst()
            _ = data?.dataSets[3].removeFirst()
            _ = data?.dataSets[4].removeFirst()
        }
        
        self.notifyDataSetChanged()
    }
    
    func graph(packets: [HETPacket]) {
        DispatchQueue.global(qos: .utility).async {
            for packet in packets {
                guard let packet = packet as? HETWristOzonePacket else {
                    return
                }
                
                let ts = packet.timestamp.timeIntervalSince1970
                
                let battery = ChartDataEntry(x: ts, y: Double(packet.battery))
                let ozoneOne = ChartDataEntry(x: ts, y: Double(packet.ozoneOne))
                let ozoneTwo = ChartDataEntry(x: ts, y: Double(packet.ozoneTwo))
                let ozoneThree = ChartDataEntry(x: ts, y: Double(packet.ozoneThree))
                let ozoneFour = ChartDataEntry(x: ts, y: Double(packet.ozoneFour))
                
                
                self.data?.addEntry(battery, dataSetIndex: 0)
                self.data?.addEntry(ozoneOne, dataSetIndex: 1)
                self.data?.addEntry(ozoneTwo, dataSetIndex: 2)
                self.data?.addEntry(ozoneThree, dataSetIndex: 3)
                self.data?.addEntry(ozoneFour, dataSetIndex: 4)
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

