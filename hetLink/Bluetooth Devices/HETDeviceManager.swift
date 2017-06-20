//
//  HETDeviceManager.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/13/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import CoreBluetooth

class HETDeviceManager : NSObject{
    
    // Bluetooth
    var bleManager : CBCentralManager!
    
    var discoveredDevices : [CBPeripheral] = []
    var connectedDevice : HETDevice!
    
    var services: [CBUUID]!
    
    // Delegation
    weak var delegate : HETDeviceManagerDelegate!
    
    init(delegate: HETDeviceManagerDelegate, services: [CBUUID]) {
        self.delegate = delegate
        self.services = services
        
        super.init()
        
        bleManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func connect(device: CBPeripheral){
        bleManager.connect(device, options: nil)
    }
}

extension HETDeviceManager : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            bleManager.scanForPeripherals(withServices: services, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let index = discoveredDevices.index(where: {$0.identifier == peripheral.identifier})
        
        if index == nil {
            discoveredDevices.append(peripheral)
        } else {
            discoveredDevices[index!] = peripheral
        }
        
        delegate.deviceManager(didDiscover: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedDevice = HETDevice(from: peripheral, delegate: self)
        delegate.deviceManager(didConnect: connectedDevice)
    }
}

extension HETDeviceManager : HETDeviceDelegate {
    func hetDevice(didUpdateValueFor characteristic: CBCharacteristic, packet: HETPacket) {
        delegate.deviceManager(didGet: packet, device: connectedDevice)
    }
}

protocol HETDeviceManagerDelegate: class {
    func deviceManager(didDiscover device: CBPeripheral)
    func deviceManager(didConnect device: HETDevice)
    func deviceManager(didGet packet: HETPacket, device: HETDevice)
}
