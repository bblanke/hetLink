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
    
    var ecgBuffer: [HETChestPacket] = []
    
    func queueForAnalysis(packet: HETPacket){
        switch packet.parser {
        case .chest:
            let packet = packet as! HETChestPacket
            ecgBuffer.append(packet)
            if ecgBuffer.count >= bpmChunkSize {
                self.calculateBPM()
            }
            break
        case .wristEnvironment:
            break
        case .wristOzone:
            break
        }
    }
    
    func calculateBPM(){
        let times = ecgBuffer.map { $0.timestamp.timeIntervalSince1970 }
        let ecg = ecgBuffer.map { Double($0.ecgOne) }
        let bpm: Double = analyzeECG(times, ecg)
        ecgBuffer.removeFirst(bpmChunkSize)
        if bpm.isNaN {
            self.delegate.analysisManager(didUpdateBPM: 0)
        } else {
            self.delegate.analysisManager(didUpdateBPM: Int(bpm))
        }
    }
}

protocol AnalysisManagerDelegate: class {
    func analysisManager(didUpdateBPM value: Int)
}
