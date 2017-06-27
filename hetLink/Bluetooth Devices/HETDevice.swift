//
//  HETDevice.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/19/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import CoreBluetooth

class HETDevice: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral
    weak var delegate: HETDeviceDelegate!
    var interpreter: HETDeviceInterpreter.Type
    
    init(from device: CBPeripheral, delegate: HETDeviceDelegate){
        self.peripheral = device
        self.delegate = delegate
        self.interpreter = HETChestInterpreter.self
        
        super.init()
        peripheral.delegate = self
        device.discoverServices(interpreter.services)
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(interpreter.characteristics[service.uuid], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        interpreter.setupNotifications(on: service.characteristics!, device: self.peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let packet = interpreter.parseData(on: characteristic)
        delegate.hetDevice(didUpdateValueFor: characteristic, packet: packet)
    }
}

protocol HETDeviceDelegate : class {
    func hetDevice(didUpdateValueFor characteristic: CBCharacteristic, packet: HETPacket)
}
