//
//  HETWatchInterpreter.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/19/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import CoreBluetooth

class HETWatchInterpreter: HETDeviceInterpreter {
    static private let dataServiceUUID = CBUUID(string: "FFF0")
    static private let enableCharacteristicUUID = CBUUID(string: "FFF1")
    static private let accelCharacteristicUUID = CBUUID(string: "FFF2")
    static private let sensorsCharacteristicUUID = CBUUID(string: "FFF3")
    
    static private let enableBuffer = Data(bytes: [1])
    
    static var services: [CBUUID] {
        return [dataServiceUUID]
    }
    
    static var characteristics: [CBUUID : [CBUUID]] {
        return [
            services[0]: [
                enableCharacteristicUUID,
                accelCharacteristicUUID,
                sensorsCharacteristicUUID
            ]
        ]
    }
    
    static func parseData(from characteristic: CBCharacteristic) -> HETPacket? {
        // FIXME: - This should have whatever watch interpreter- not the chest body interpreter
        print("got data from \(characteristic.uuid.uuidString)")
        print(characteristic.value!)
        
        guard let packet = HETEcgPulseOxPacket(data: characteristic.value!, date: Date()) else {
            return nil
        }
        
        return packet
    }
    
    static func setupNotifications(on characteristics: [CBCharacteristic], device: CBPeripheral) {
        for char in characteristics {
            print(char.uuid.uuidString)

            if char.uuid == enableCharacteristicUUID {
                device.writeValue(enableBuffer, for: char, type: .withResponse)
            }
            if char.uuid == accelCharacteristicUUID {
                device.setNotifyValue(true, for: char)
            }
            if char.uuid == sensorsCharacteristicUUID {
                device.setNotifyValue(true, for: char)
            }
        }
    }
}
