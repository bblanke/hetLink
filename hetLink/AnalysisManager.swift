//
//  AnalysisManager.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/12/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation

class AnalysisManager: NSObject {
    var ecgSamples: Int = 0
    var ecgAverage: Double = 0
    
    func analyze(hetPacket packet: HETPacket){
        
        switch packet.parser {
        case .ecgPulseOx:
            let packet = packet as! HETEcgPulseOxPacket
            ecgAverage = calculateRunningAverage(average: ecgAverage, oldSamples: ecgSamples, newValue: Double(packet.ecg))
            print(ecgAverage)
            break
        case .battAccel:
            break
        }
    }
    
    private func calculateRunningAverage(average: Double, oldSamples: Int, newValue: Double) -> Double {
        return (((Double(oldSamples) * average) + newValue) / Double(oldSamples + 1))
    }
}
