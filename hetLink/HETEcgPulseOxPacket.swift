//
//  HETChestPacket.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/20/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation

class HETEcgPulseOxPacket: HETPacket {
    let rawData: Data
    let timestamp: Date
    let device: HETDeviceType
    let parser: HETParserType
    
    let ecg: Int
    let waveOne: Int
    let waveTwo: Int
    let waveThree: Int
    let waveFour: Int
    
    required init?(data: Data, date: Date, device: HETDeviceType){
        guard data.count == 20 else {
            return nil
        }
        
        self.rawData = data
        self.timestamp = date
        self.device = device
        self.parser = .ecgPulseOx
        
        self.ecg = (Int(data[0]) << 16) + (Int(data[1]) << 8) + Int(data[2])
        self.waveOne = (Int(data[13]) << 8) + Int(data[12])
        self.waveTwo = (Int(data[15]) << 8) + Int(data[14])
        self.waveThree = (Int(data[17]) << 8) + Int(data[16])
        self.waveFour = (Int(data[19]) << 8) + Int(data[18])
    }
}
