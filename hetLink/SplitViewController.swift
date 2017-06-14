//
//  SplitViewController.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/14/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import CoreBluetooth

class SplitViewController: UISplitViewController {

    var bleDeviceManager : HETDeviceManager!
    
    var devicesViewController : DevicesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bleDeviceManager = HETDeviceManager(delegate: self)
        
        let masterNavigationController = viewControllers.first! as! UINavigationController
        devicesViewController = masterNavigationController.topViewController as! DevicesViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SplitViewController: HETDeviceManagerDelegate {
    func didDiscoverHETDevice(device: CBPeripheral) {
        devicesViewController.reloadHETDevices(devices: bleDeviceManager.discoveredDevices)
    }
}
