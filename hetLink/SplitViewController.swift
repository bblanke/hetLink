//
//  SplitViewController.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/14/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import CoreBluetooth

class SplitViewController: UISplitViewController{

    var bleDeviceManager : HETDeviceManager!
    
    var masterVC : MasterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bleDeviceManager = HETDeviceManager(delegate: self)
        
        let masterNavigationController = viewControllers.first! as! UINavigationController
        masterVC = masterNavigationController.topViewController as! MasterViewController
        
        masterVC.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SplitViewController: HETDeviceManagerDelegate {
    func deviceManager(didDiscover device: CBPeripheral){
        masterVC.reloadHETDevices(devices: bleDeviceManager.discoveredDevices)
    }
    
    func deviceManager(didConnect device: CBPeripheral) {
        print("connected a device")
    }
}

extension SplitViewController: DeviceListDelegate {
    func deviceList(didSelect device: CBPeripheral) {
        bleDeviceManager.connect(device: device)
    }
}
