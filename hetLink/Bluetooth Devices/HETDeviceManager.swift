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
    let chestPatchServiceUUID = CBUUID(string: "FFF0")
    let watchServiceUUID = CBUUID(string: "FFF0")
    let hetServiceUUIDS : [CBUUID]
    
    // Delegation
    weak var delegate : HETDeviceManagerDelegate!
    
    init(delegate: HETDeviceManagerDelegate) {
        self.hetServiceUUIDS = [chestPatchServiceUUID, watchServiceUUID]
        self.delegate = delegate
        
        super.init()
        
        bleManager = CBCentralManager(delegate: self, queue: nil)
    }
}

extension HETDeviceManager : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            bleManager.scanForPeripherals(withServices: hetServiceUUIDS, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let index = discoveredDevices.index(where: {$0.identifier == peripheral.identifier})
        
        if index == nil {
            discoveredDevices.append(peripheral)
        } else {
            discoveredDevices[index!] = peripheral
        }
        
        delegate.didDiscoverHETDevice(device: peripheral)
    }
}

protocol HETDeviceManagerDelegate: class {
    func didDiscoverHETDevice(device: CBPeripheral)
}
