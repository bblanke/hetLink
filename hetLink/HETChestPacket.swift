//
//  HETChestPacket.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/20/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation

class HETChestPacket: HETPacket {
    let rawData: Data
    let timestamp: Date
    let parser: HETParserType
    
    static let attributeCount: Int = 10
    static var attributeCSVExportHeader: String = "Battery, ECG 1, ECG 2, ECG 3, Wave 1, Wave 2, Wave 3, X, Y, Z"
    
    let battery: Int
    let ecgOne: Int
    let ecgTwo: Int
    let ecgThree: Int
    let waveOne: Int
    let waveTwo: Int
    let waveThree: Int
    let x: Int8
    let y: Int8
    let z: Int8
    
    required init?(data: Data, date: Date){
        self.rawData = data
        self.timestamp = date
        self.parser = .chest
        
        self.battery = (Int(data[0]) << 8) + Int(data[1])
        self.ecgOne = (Int(data[2]) << 16) + (Int(data[3]) << 8) + Int(data[4])
        self.ecgTwo = (Int(data[5]) << 16) + (Int(data[6]) << 8) + Int(data[7])
        self.ecgThree = (Int(data[8]) << 16) + (Int(data[9]) << 8) + Int(data[10])
        self.waveOne = (Int(data[11]) << 8) + Int(data[12])
        self.waveTwo = (Int(data[13]) << 8) + Int(data[14])
        self.waveThree = (Int(data[15]) << 8) + Int(data[16])
        self.x = Int8(bitPattern: data[17])
        self.y = Int8(bitPattern: data[18])
        self.z = Int8(bitPattern: data[19])
    }
    
    func toCSV() -> String {
        return "\(battery), \(ecgOne), \(ecgTwo), \(ecgThree), \(waveOne), \(waveTwo), \(waveThree), \(x), \(y), \(z)"
    }
}
