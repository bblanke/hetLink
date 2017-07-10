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
        
        masterVC.masterListDelegate = self
        masterVC.recordingManager = recordingManager
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
        detailVC.setupGraphs(for: device.type, mode: .device)
    }
    
    func deviceManager(didGet packet: HETPacket) {
        detailVC.graph(packet: packet)
        if recordingManager.isRecording {
            recordingManager.persist(packet: packet)
        }
    }
}

extension SplitViewController: MasterListDelegate {
    func masterList(didSelectDevice device:CBPeripheral) {
        hetDeviceManager.connect(device: device)
    }
    
    func masterList(didSelectRecording recording: Recording) {
        hetDeviceManager.disconnectCurrentDevice()
        masterVC.isDisabled = true
        let deviceType = HETDeviceType(rawValue: recording.deviceType)!
        detailVC.setupGraphs(for: deviceType, mode: .file)
        detailVC.progressView.isHidden = false
        detailVC.progressView.progress = 0.0
        
        let packets = recording.packets!.array as! [Packet]
        let totalCount = packets.count
        for (index, packet) in packets.enumerated() {
            detailVC.progressView.progress = Float(index)/Float(totalCount)
            switch HETParserType(rawValue: packet.parseType)!{
            case .ecgPulseOx:
                detailVC.graph(packet: HETEcgPulseOxPacket(data: packet.data! as Data, date: packet.timestamp! as Date)!)
                break
            case .battAccel:
                detailVC.graph(packet: HETBattAccelPacket(data: packet.data! as Data, date: packet.timestamp! as Date)!)
                break
            }
        }
        
        detailVC.progressView.isHidden = true
        masterVC.isDisabled = false
    }
}

extension SplitViewController: ChartViewDelegate {
    func chartView(didToggle recording: Bool) {
        masterVC.isDisabled = recording
        if recording {
            recordingManager.startRecording(type: hetDeviceManager.connectedDevice.type)
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
