//
//  HETEnvironmentPacket.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/27/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation

class HETEnvironmentPacket: HETPacket {
    let rawData: Data
    let timestamp: Date
    let parser: HETParserType
    
    static let attributeCount: Int = 4
    static var attributeCSVExportHeader: String = "COTS Ozone, ASSIST Ozone, Temperature, Humidity"
    
    let cotsOzone: Int
    let assistOzone: Int
    let temperature: Int
    let humidity: Int
    
    required init?(data: Data, date: Date){
        guard data.count == 12 else {
            return nil
        }
        
        self.rawData = data
        self.timestamp = date
        self.parser = .environment
        
        self.cotsOzone = (Int(data[0]) << 8) + (Int(data[1]))
        self.assistOzone = (Int(data[2]) << 8) + Int(data[3])
        self.temperature = (Int(data[4]) << 8) + Int(data[5])
        self.humidity = (Int(data[6]) << 8) + Int(data[7])        
    }
    
    func toCSV() -> String {
        return "\(cotsOzone), \(assistOzone), \(temperature), \(humidity)"
    }
}

