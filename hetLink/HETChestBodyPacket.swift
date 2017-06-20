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
    
    var ecg: Int
    var wave1: Int
    var wave2: Int
    var wave3: Int
    var wave4: Int
    
    required init(packet: Data){
        self.rawData = packet
        
        self.ecg = (Int(packet[0]) << 16) + (Int(packet[1]) << 8) + Int(packet[2])
        self.wave1 = (Int(packet[13]) << 8) + Int(packet[12])
        self.wave2 = (Int(packet[15]) << 8) + Int(packet[14])
        self.wave3 = (Int(packet[17]) << 8) + Int(packet[16])
        self.wave4 = (Int(packet[19]) << 8) + Int(packet[18])
    }
}
