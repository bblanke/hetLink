//
//  HETEnvironmentPacket.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/27/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation

class HETWristOzonePacket: HETPacket {
    let rawData: Data
    let timestamp: Date
    let parser: HETParserType
    
    static let attributeCount: Int = 4
    static var attributeCSVExportHeader: String = "Oz 1, Oz 2, Oz 3, Oz 4, Battery"
    
    let ozoneOne: Int
    let ozoneTwo: Int
    let ozoneThree: Int
    let ozoneFour: Int
    let battery: Int
    
    required init?(data: Data, date: Date){
        self.rawData = data
        self.timestamp = date
        self.parser = .wristOzone
        
        self.ozoneOne = (Int(data[0]) << 8) + (Int(data[1]))
        self.ozoneTwo = (Int(data[2]) << 8) + (Int(data[3]))
        self.ozoneThree = (Int(data[4]) << 8) + (Int(data[5]))
        self.ozoneFour = (Int(data[6]) << 8) + (Int(data[7]))
        self.battery = (Int(data[8]) << 8) + (Int(data[9]))
    }
    
    func toCSV() -> String {
        return "\(ozoneOne), \(ozoneTwo), \(ozoneThree), \(ozoneFour), \(battery)"
    }
}

