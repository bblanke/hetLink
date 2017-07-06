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

    var hetDeviceManager: HETDeviceManager!
    
    var masterVC: MasterViewController!
    var detailVC: DetailViewController!
    
    var recordingManager: RecordingManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hetDeviceManager = HETDeviceManager(delegate: self, services: HETWatchInterpreter.services)
        
        let masterNC = viewControllers[0] as! UINavigationController
        masterVC = masterNC.topViewController as! MasterViewController
        
        let detailNC = viewControllers[1] as! UINavigationController
        detailVC = detailNC.topViewController as! DetailViewController
        
        masterVC.deviceListDelegate = self
        masterVC.recordingsController = recordingManager.fetchedRecordingsController
        detailVC.chartDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SplitViewController: HETDeviceManagerDelegate {
    func deviceManager(didDiscover device: CBPeripheral){
        masterVC.reloadHETDevices(devices: hetDeviceManager.discoveredDevices)
    }
    
    func deviceManager(didConnect device: HETDevice) {
        detailVC.setupGraphs(for: device)
    }
    
    func deviceManager(didGet packet: HETPacket) {
        detailVC.graph(packet: packet)
        if recordingManager.isRecording {
            recordingManager.persist(packet: packet)
        }
    }
}

extension SplitViewController: DeviceListDelegate {
    func deviceList(didSelect device: CBPeripheral) {
        hetDeviceManager.connect(device: device)
    }
}

extension SplitViewController: ChartViewDelegate {
    func chartView(didToggleRecording status: Bool) {
        if status {
            recordingManager.startRecording()
        } else {
            let alertController = UIAlertController(title: "Save Recording", message: "Please choose a name for the recording", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action) in
                if (alertController.textFields?.count)! > 0 {
                    let nameField = alertController.textFields?.first
                    self.recordingManager.endRecording(recordingTitle: (nameField?.text)!)
                }
            })
            alertController.addAction(saveAction)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "File name"
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
