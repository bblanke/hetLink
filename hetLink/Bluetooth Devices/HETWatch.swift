//
//  HETWatch.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/16/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import CoreBluetooth

class HETWatch: NSObject, CBPeripheralDelegate, HETDevice {
    
    // Services and Characteristics
    let dataService = CBUUID(string: "FFF0")
    
    let enableCharacteristicUUID = CBUUID(string: "FFF1")
    let pulseOxCharacteristicUUID = CBUUID(string: "FFF3")
    let battAccelCharacteristicUUID = CBUUID(string: "FFF4")
    
    let enableBuffer = Data(bytes: [1])
    
    var deviceDelegate: HETDeviceDelegate!
    var bluetoothDevice : CBPeripheral!
    
    required init(device: CBPeripheral, delegate: HETDeviceDelegate){
        super.init()
        
        deviceDelegate = delegate

        bluetoothDevice = device
        bluetoothDevice.delegate = self
        
        bluetoothDevice.discoverServices([dataService])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        bluetoothDevice.discoverCharacteristics([enableCharacteristicUUID, pulseOxCharacteristicUUID, battAccelCharacteristicUUID], for: (peripheral.services?.first)!)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for char in characteristics {
                if char.uuid == enableCharacteristicUUID {
                    bluetoothDevice.writeValue(enableBuffer, for: char, type: .withResponse)
                } else if char.uuid == pulseOxCharacteristicUUID {
                    bluetoothDevice.setNotifyValue(true, for: char)
                } else if char.uuid == battAccelCharacteristicUUID {
                    bluetoothDevice.setNotifyValue(true, for: char)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        deviceDelegate.hetDevice(didUpdateValueFor: characteristic)
    }
}
