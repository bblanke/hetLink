//
//  HETDeviceInterpreter.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/19/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol HETDeviceInterpreter: class {
    static var services: [CBUUID] { get }
    static var characteristics: [CBUUID: [CBUUID]] { get }
    
    static func parseData(from characteristic: CBCharacteristic) -> HETPacket?
    static func setupNotifications(on characteristics: [CBCharacteristic], device: CBPeripheral)
}
