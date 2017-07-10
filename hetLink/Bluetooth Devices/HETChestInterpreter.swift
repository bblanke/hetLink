//
//  HETChestInterpreter.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/19/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import CoreBluetooth

class HETChestInterpreter: HETDeviceInterpreter {
    static private let dataServiceUUID = CBUUID(string: "FFF0")
    static private let enableCharacteristicUUID = CBUUID(string: "FFF1")
    static private let ecgCharacteristicUUID = CBUUID(string: "FFF2")
    static private let accelCharacteristicUUID = CBUUID(string: "FFF5")
    
    static private let enableBuffer = Data(bytes: [1])
    
    static var services: [CBUUID] {
        return [dataServiceUUID]
    }
    
    static var characteristics: [CBUUID : [CBUUID]] {
        return [
            dataServiceUUID: [
                enableCharacteristicUUID,
                ecgCharacteristicUUID,
                accelCharacteristicUUID
            ]
        ]
    }
    
    static func parseData(from characteristic: CBCharacteristic) -> HETPacket? {
        if characteristic.uuid == accelCharacteristicUUID {
            guard let packet = HETBattAccelPacket(data: characteristic.value!, date: Date()) else {
                return nil
            }
            return packet
        } else if characteristic.uuid == ecgCharacteristicUUID {
            guard let packet = HETEcgPulseOxPacket(data: characteristic.value!, date: Date()) else {
                return nil
            }
            return packet
        } else {
            return nil
        }
    }
    
    static func setupNotifications(on characteristics: [CBCharacteristic], device: CBPeripheral) {
        for char in characteristics {
            print(char.uuid.uuidString)
            if char.uuid == enableCharacteristicUUID {
                device.writeValue(enableBuffer, for: char, type: .withResponse)
            } else if char.uuid == ecgCharacteristicUUID {
                device.setNotifyValue(true, for: char)
            } else if char.uuid == accelCharacteristicUUID {
                device.setNotifyValue(true, for: char)
            }
        }
    }
}
