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
    var timestamp: Double { get }
    var device: HETDeviceType { get }
    var parser: HETParserType { get }
    
    init?(data: Data, date: Date, device: HETDeviceType)
}

enum HETDeviceType {
    case chest, watch
}

enum HETParserType {
    case ecgPulseOx, battAccel
}
