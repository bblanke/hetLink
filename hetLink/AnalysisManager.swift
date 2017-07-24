//
//  AnalysisManager.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/12/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation

class AnalysisManager: NSObject {
    weak var delegate: AnalysisManagerDelegate!
    let bpmChunkSize: Int = 400
    
    var ecgPulseOxPacketBuffer: [HETEcgPulseOxPacket] = []
    
    func queueForAnalysis(packet: HETPacket){
        switch packet.parser {
        case .ecgPulseOx:
            let packet = packet as! HETEcgPulseOxPacket
            ecgPulseOxPacketBuffer.append(packet)
            if ecgPulseOxPacketBuffer.count >= bpmChunkSize {
                calculateBPM()
            }
            break
        case .battAccel:
            break
        }
    }
    
    func calculateBPM(){
        let times = ecgPulseOxPacketBuffer.map { $0.timestamp.timeIntervalSince1970 }
        let ecg = ecgPulseOxPacketBuffer.map { Double($0.ecg) }
        let bpm: Double = analyzeECG(times, ecg)
        if bpm.isNaN {
            delegate.analysisManager(didUpdateBPM: 0)
        } else {
            delegate.analysisManager(didUpdateBPM: Int(bpm))
        }
        ecgPulseOxPacketBuffer.removeFirst(bpmChunkSize)
    }
}

protocol AnalysisManagerDelegate: class {
    func analysisManager(didUpdateBPM value: Int)
}
