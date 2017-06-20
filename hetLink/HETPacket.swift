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
    
    init(packet: Data)
}