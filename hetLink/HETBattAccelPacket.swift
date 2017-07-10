//
//  HETBattAccel.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/28/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation

class HETBattAccelPacket: HETPacket {
    let rawData: Data
    let timestamp: Date
    let parser: HETParserType
    
    static var attributeCount: Int = 3
    static var attributeCSVExportHeader: String = "X, Y, Z"
    
    let x: Int8
    let y: Int8
    let z: Int8
    
    required init?(data: Data, date: Date){
        guard data.count == 7 else {
            return nil
        }
        
        self.rawData = data
        self.timestamp = date
        self.parser = .battAccel
        
        self.x = Int8(bitPattern: data[0])
        self.y = Int8(bitPattern: data[1])
        self.z = Int8(bitPattern: data[2])
    }
    
    func toCSV() -> String {
        return "\(x), \(y), \(z)"
    }
}
