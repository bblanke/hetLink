//
//  HETPacket.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/20/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation

protocol HETPacket: class {
    var rawData: Data { get }
    var timestamp: Date { get }
    var device: HETDeviceType { get }
    var parser: HETParserType { get }
    
    init?(data: Data, date: Date, device: HETDeviceType)
}

enum HETDeviceType: Int16 {
    case chest, watch
}

enum HETParserType: Int16 {
    case ecgPulseOx, battAccel
}
