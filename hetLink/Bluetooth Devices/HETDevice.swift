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
    var type: HETDeviceType!
    
    init(from device: CBPeripheral, delegate: HETDeviceDelegate){
        self.peripheral = device
        self.delegate = delegate
        self.interpreter = HETChestInterpreter.self // TODO: Find a way to differentiate between devices to apply the correct interpreter
        self.type = .chest
        
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
        guard let packet = interpreter.parseData(from: characteristic) else {
            return
        }
        
        delegate.hetDevice(didUpdateValueFor: characteristic, packet: packet)
    }
}

protocol HETDeviceDelegate : class {
    func hetDevice(didUpdateValueFor characteristic: CBCharacteristic, packet: HETPacket)
}

enum HETDeviceType: Int16 {
    case chest, watch
}
