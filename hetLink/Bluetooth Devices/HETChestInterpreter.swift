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
    
    static func parseData(on characteristic: CBCharacteristic) -> [Double] {
        if characteristic.uuid == ecgCharacteristicUUID {
            return [parseEcg(data: characteristic.value!)]
        } else {
            return parseAccel(data: characteristic.value!)
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
    
    static private func parseEcg(data: Data) -> Double {
        return Double((Int(data[0]) << 16) + (Int(data[1]) << 8) + Int(data[2]))
    }
    
    static private func parseAccel(data: Data) -> [Double] {
        return [Double(data[0]), Double(data[1]), Double(data[2])]
    }
}
