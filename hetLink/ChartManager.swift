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
        case .watch: break
        }
        
        
        for chartView in chartViews {
            frameView.addSubview(chartView as! UIView)
        }
        
        currentDeviceType = deviceType
    }
    
    func graph(packet: HETPacket){
        guard currentDeviceType != nil else {
            print("[WARNING]: Trying to graph without charts")
            return
        }
        
        switch currentDeviceType! {
        case .chest:
            switch packet.parser {
            case .ecgPulseOx:
                chartViews[0].graph(packet: packet)
                break
            case .battAccel:
                chartViews[1].graph(packet: packet)
                break
            }
            break
        case .watch:
            break
        }
    }
    
    private func createFrames(in frame: CGRect, number: Int) -> [CGRect]{
        let padding = 20
        let width: Int = Int(frame.width)
        let height: Int = (Int(frame.height) / number) - ((number - 1) * padding)
        
        let x: Int = Int(frame.minX)
        
        var frames: [CGRect] = []
        for i in 0..<number {
            let y: Int = Int(frame.minY) + height * i + padding * i
            frames.append(CGRect(x: x, y: y, width: width, height: height))
        }
        
        return frames
    }

}
