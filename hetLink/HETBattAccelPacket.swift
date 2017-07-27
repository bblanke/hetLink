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
        self.rawData = data
        self.timestamp = date
        self.parser = .battAccel
        
        if data.count == 7 {
            self.x = Int8(bitPattern: data[0])
            self.y = Int8(bitPattern: data[1])
            self.z = Int8(bitPattern: data[2])
        } else if data.count == 6 {
            self.x = Int8(bitPattern: data[2])
            self.y = Int8(bitPattern: data[3])
            self.z = Int8(bitPattern: data[4])
        } else {
            return nil
        }
        print(self.toCSV())
    }
    
    func toCSV() -> String {
        return "\(x), \(y), \(z)"
    }
}
