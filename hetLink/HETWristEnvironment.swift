//
//  HETBattAccel.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/28/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation

class HETWristEnvironmentECG: HETPacket {
    let rawData: Data
    let timestamp: Date
    let parser: HETParserType
    
    static var attributeCount: Int = 3
    static var attributeCSVExportHeader: String = "Wave 1, Wave 2, Wave 3, X, Y, Z, Temp, Humidity"
    
    let waveOne: Int
    let waveTwo: Int
    let waveThree: Int
    let x: Int8
    let y: Int8
    let z: Int8
    let temp: Int
    let humidity: Int
    
    required init?(data: Data, date: Date){
        self.rawData = data
        self.timestamp = date
        self.parser = .wristEnvironment
        
        self.waveOne = (Int(data[1]) << 8) + Int(data[0])
        self.waveTwo = (Int(data[3]) << 8) + Int(data[2])
        self.waveThree = (Int(data[5]) << 8) + Int(data[4])
        
        self.x = Int8(bitPattern: data[7])
        self.y = Int8(bitPattern: data[8])
        self.z = Int8(bitPattern: data[9])
        
        self.temp = (Int(data[10]) << 8) + Int(data[11])
        self.humidity = (Int(data[12]) << 8) + Int(data[13])
    }
    
    func toCSV() -> String {
        return "\(waveOne), \(waveTwo), \(waveThree), \(x), \(y), \(z), \(temp), \(humidity)"
    }
}
