//
//  HETEnvironmentChartView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/27/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import Charts

class HETEnvironmentChartView: ChartView, HETChartView {
        
    // Datasets
    var cotsOzoneDataSet: LineChartDataSet!
    var assistOzoneDataSet: LineChartDataSet!
    var temperatureDataSet: LineChartDataSet!
    var humidityDataSet: LineChartDataSet!
    
    var chartData: ChartData!
    var chartDataSets: [LineChartDataSet]!
    
    let chartColors: [UIColor] = Array(Theme.graphColors[0...3])
    
    let range: Int = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initChart(){
        cotsOzoneDataSet = LineChartDataSet(values: [], label: "COTS Ozone")
        assistOzoneDataSet = LineChartDataSet(values: [], label: "ASSIST Ozone")
        temperatureDataSet = LineChartDataSet(values: [], label: "Temperature")
        humidityDataSet = LineChartDataSet(values: [], label: "Humidity")
        
        chartDataSets = [cotsOzoneDataSet, assistOzoneDataSet, temperatureDataSet, humidityDataSet]
        
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
        guard let packet = packet as? HETEnvironmentPacket else {
            return
        }
        
        let ts = packet.timestamp.timeIntervalSince1970
        
        let cotsOzoneEntry = ChartDataEntry(x: ts, y: Double(packet.cotsOzone))
        let assistOzoneEntry = ChartDataEntry(x: ts, y: Double(packet.assistOzone))
        let temperatureEntry = ChartDataEntry(x: ts, y: Double(packet.temperature))
        let humidityEntry = ChartDataEntry(x: ts, y: Double(packet.humidity))
        
        self.data?.addEntry(cotsOzoneEntry, dataSetIndex: 0)
        self.data?.addEntry(assistOzoneEntry, dataSetIndex: 1)
        self.data?.addEntry(temperatureEntry, dataSetIndex: 2)
        self.data?.addEntry(humidityEntry, dataSetIndex: 3)
        
        let first = self.data?.dataSets[0].entryForIndex(0)
        
        self.xAxis.axisMinimum = (first?.x)!
        
        if (self.data?.dataSets[0].entryCount)! > self.range {
            _ = self.data?.dataSets[0].removeFirst()
            _ = self.data?.dataSets[1].removeFirst()
            _ = self.data?.dataSets[2].removeFirst()
            _ = self.data?.dataSets[3].removeFirst()
        }
        self.notifyDataSetChanged()
    }
    
    func graph(packets: [HETPacket]) {
        DispatchQueue.global(qos: .utility).async {
            for packet in packets {
                guard let packet = packet as? HETEnvironmentPacket else {
                    return
                }
                
                let ts = packet.timestamp.timeIntervalSince1970
                
                let cotsOzoneEntry = ChartDataEntry(x: ts, y: Double(packet.cotsOzone))
                let assistOzoneEntry = ChartDataEntry(x: ts, y: Double(packet.assistOzone))
                let temperatureEntry = ChartDataEntry(x: ts, y: Double(packet.temperature))
                let humidityEntry = ChartDataEntry(x: ts, y: Double(packet.humidity))
                
                self.data?.addEntry(cotsOzoneEntry, dataSetIndex: 0)
                self.data?.addEntry(assistOzoneEntry, dataSetIndex: 1)
                self.data?.addEntry(temperatureEntry, dataSetIndex: 2)
                self.data?.addEntry(humidityEntry, dataSetIndex: 3)
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
