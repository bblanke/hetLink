//
//  File.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/12/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import UIKit

class ChartManager: NSObject {
    var chartViews: [HETChartView] = []
    var currentDeviceType: HETDeviceType?
    
    func setupGraphView(for deviceType: HETDeviceType, frameView: UIView){
        print("setting up graph view for \(deviceType)")
        // Clear out the frame
        for view in frameView.subviews{
            view.removeFromSuperview()
        }
        chartViews = []
        
        // Add the needed charts
        switch deviceType {
        case .chest:
            let frames = createFrames(in: frameView.frame, number: 2)
            chartViews.append(HETChestBodyChartView(frame: frames[0]))
            chartViews.append(HETChestAccelChartView(frame: frames[1]))
            break
        case .watch:
            let frames = createFrames(in: frameView.frame, number: 4)
            chartViews.append(HETWristOzoneChartView(frame: frames[0]))
            chartViews.append(HETWristEnvironmentChartView(frame: frames[1]))
            chartViews.append(HETWristAccelChartView(frame: frames[2]))
            chartViews.append(HETWristPulseOxChartView(frame: frames[3]))
        }
        
        
        for chartView in chartViews {
            frameView.addSubview(chartView as! UIView)
        }
        
        currentDeviceType = deviceType
    }
    
    func graph(packet: HETPacket){
        guard currentDeviceType != nil else {
            fatalError("Trying to graph without charts")
        }
        
        switch currentDeviceType! {
        case .chest:
            switch packet.parser {
            case .chest:
                chartViews[0].graph(packet: packet)
                chartViews[1].graph(packet: packet)
                break
            default:
                break
            }
            break
        case .watch:
            switch packet.parser{
            case .chest:
                break
            case .wristOzone:
                chartViews[0].graph(packet: packet)
                break
            case .wristEnvironment:
                chartViews[1].graph(packet: packet)
                chartViews[2].graph(packet: packet)
                chartViews[3].graph(packet: packet)
                break
            }
        }
    }
    
    func graph(packets: [HETPacket]){
        guard currentDeviceType != nil else {
            fatalError("Trying to graph without charts")
        }
        
        switch currentDeviceType! {
        case .chest:
            let chestPackets = packets.filter { $0.parser == HETParserType.chest }
            chartViews[0].graph(packets: chestPackets)
            chartViews[1].graph(packets: chestPackets)
            break
        case .watch:
            let environmentPackets = packets.filter { $0.parser == HETParserType.wristEnvironment }
            let ozonePackets = packets.filter { $0.parser == HETParserType.wristOzone }
            chartViews[0].graph(packets: ozonePackets)
            chartViews[1].graph(packets: environmentPackets)
            chartViews[2].graph(packets: environmentPackets)
            chartViews[3].graph(packets: environmentPackets)
        }
    }
    
    private func createFrames(in frame: CGRect, number: Int) -> [CGRect]{
        let padding = 20
        let width: Int = Int(frame.width)
        let height: Int = (Int(frame.height) / number)
        
        var frames: [CGRect] = []
        for i in 0..<number {
            let y: Int = height * i
            frames.append(CGRect(x: 0, y: y, width: width, height: height))
        }
        
        return frames
    }

}
