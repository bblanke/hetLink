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

    var hetDeviceManager : HETDeviceManager!
    
    var masterVC : MasterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hetDeviceManager = HETDeviceManager(delegate: self, services: HETWatchInterpreter.services)
        
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
        masterVC.reloadHETDevices(devices: hetDeviceManager.discoveredDevices)
    }
    
    func deviceManager(didConnect device: HETDevice) {
        print("nice we connected")
    }
    
    func deviceManager(didGet packet: HETPacket, device: HETDevice) {
        let packet = packet as! HETChestBodyPacket
        print("[DEBUG]: \(packet.ecg) | \(packet.wave1)")
    }
}

extension SplitViewController: DeviceListDelegate {
    func deviceList(didSelect device: CBPeripheral) {
        hetDeviceManager.connect(device: device)
    }
}
