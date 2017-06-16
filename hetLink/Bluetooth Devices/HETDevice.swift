//
//  HETDevice.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/16/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol HETDevice : class {
    var deviceDelegate : HETDeviceDelegate! { get set }
    
    init(device: CBPeripheral, delegate: HETDeviceDelegate)
}

protocol HETDeviceDelegate : class {
    func hetDevice(didUpdateValueFor characteristic: CBCharacteristic)
}
