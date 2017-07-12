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
    var ecgAverage: Int = 0
    
    var delegate: AnalysisManagerDelegate!
    
    func analyze(packet: HETPacket){
        
        switch packet.parser {
        case .ecgPulseOx:
            let packet = packet as! HETEcgPulseOxPacket
            
            ecgSamples += 1
            ecgAverage = calculateRunningAverage(average: ecgAverage, oldSamples: ecgSamples, newValue: packet.ecg)
            checkForPeak(difference: (packet.ecg - ecgAverage), time: packet.timestamp)
            
            // If the signal gets wonky, reset the average
            if abs(packet.ecg - ecgAverage) > 50000 {
                ecgAverage = packet.ecg
                ecgSamples = 0
            }
            break
        case .battAccel:
            break
        }
    }
    
    private func calculateRunningAverage(average: Int, oldSamples: Int, newValue: Int) -> Int {
        return ((oldSamples * average) + newValue) / (oldSamples + 1)
    }
    
    var lastPeakTime: Date = Date()
    private var bpm: Int = 0
    var atPeak: Bool = false {
        didSet {
            if atPeak {
                let now = Date()
                bpm = Int((1 / now.timeIntervalSince(lastPeakTime))*60)
                lastPeakTime = now
                print("bpm is \(bpm)")
                delegate.analysisManager(didUpdateBPM: bpm)
            }
        }
    }
    let peakThreshold = 20000
    let timeThreshold = 0.5
    private func checkForPeak(difference: Int, time: Date){
        if difference > peakThreshold && time.timeIntervalSince(lastPeakTime) > timeThreshold {
            atPeak = true
        } else {
            atPeak = false
        }
    }
}

protocol AnalysisManagerDelegate: class {
    func analysisManager(didUpdateBPM value: Int)
}
