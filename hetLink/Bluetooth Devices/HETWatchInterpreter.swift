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
    static private let ozoneCharacteristicUUID = CBUUID(string: "FFF3")
    static private let environmentCharacteristicUUID = CBUUID(string: "FFF4")
    
    static private let enableBuffer = Data(bytes: [1])
    
    static var services: [CBUUID] {
        return [dataServiceUUID]
    }
    
    static var characteristics: [CBUUID : [CBUUID]] {
        return [
            services[0]: [
                enableCharacteristicUUID,
                ozoneCharacteristicUUID,
                environmentCharacteristicUUID
            ]
        ]
    }
    
    static func parseData(from characteristic: CBCharacteristic) -> HETPacket? {
        if characteristic.uuid == ozoneCharacteristicUUID {
            guard let packet = HETWristOzonePacket(data: characteristic.value!, date: Date()) else {
                return nil
            }
            return packet
        } else if characteristic.uuid == environmentCharacteristicUUID {
            guard let packet = HETWristEnvironmentECG(data: characteristic.value!, date: Date()) else {
                return nil
            }
            return packet
        } else {
            return nil
        }
    }
    
    static func setupNotifications(on characteristics: [CBCharacteristic], device: CBPeripheral) {
        for char in characteristics {
            if char.uuid == enableCharacteristicUUID {
                device.writeValue(enableBuffer, for: char, type: .withResponse)
            }
            if char.uuid == ozoneCharacteristicUUID {
                device.setNotifyValue(true, for: char)
            }
            if char.uuid == environmentCharacteristicUUID {
                device.setNotifyValue(true, for: char)
            }
        }
    }
}
