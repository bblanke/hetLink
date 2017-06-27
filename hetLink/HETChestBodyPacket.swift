//
//  HETChestPacket.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/20/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation

class HETChestBodyPacket: HETPacket {
    var rawData: Data
    var timestamp: Double
    
    var ecg: Int
    var waveOne: Int
    var waveTwo: Int
    var waveThree: Int
    var waveFour: Int
    
    required init(packet: Data, date: Date){
        self.rawData = packet
        self.timestamp = date.timeIntervalSince1970
        
        self.ecg = (Int(packet[0]) << 16) + (Int(packet[1]) << 8) + Int(packet[2])
        self.waveOne = (Int(packet[13]) << 8) + Int(packet[12])
        self.waveTwo = (Int(packet[15]) << 8) + Int(packet[14])
        self.waveThree = (Int(packet[17]) << 8) + Int(packet[16])
        self.waveFour = (Int(packet[19]) << 8) + Int(packet[18])
    }
}
