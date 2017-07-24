//
//  SplitViewController.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/14/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import CoreBluetooth
import ChameleonFramework

class SplitViewController: UISplitViewController{

    var hetDeviceManager: HETDeviceManager!
    
    var masterVC: MasterViewController!
    var detailVC: DetailViewController!
    
    var recordingManager: RecordingManager!
    
    var exportManager: ExportManager!
    
    var chartManager: ChartManager!
    
    var analysisManager: AnalysisManager!
    
    var presentedRecording: Recording!
    var presentedRecordingPackets: [HETPacket]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        self.view.backgroundColor = ContrastColorOf(Theme.graphViewBackground, returnFlat: true)
        
        hetDeviceManager = HETDeviceManager(delegate: self, services: HETWatchInterpreter.services)
        
        exportManager = ExportManager()
        
        chartManager = ChartManager()
        
        analysisManager = AnalysisManager()
        
        let masterNC = viewControllers[0] as! UINavigationController
        masterVC = masterNC.topViewController as! MasterViewController
        
        let detailNC = viewControllers[1] as! UINavigationController
        detailVC = detailNC.topViewController as! DetailViewController
        detailVC.chartManager = chartManager
        
        analysisManager.delegate = detailVC
        
        masterVC.masterListDelegate = self
        masterVC.recordingManager = recordingManager
        detailVC.chartDelegate = self
        
        recordingManager.delegate = self
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
        chartManager.setupGraphView(for: device.type, frameView: detailVC.chartsFrame)
        detailVC.setMode(mode: .device)
    }
    
    func deviceManager(didGet packet: HETPacket) {
        chartManager.graph(packet: packet)
        analysisManager.queueForAnalysis(packet: packet)
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
        print("Selected recording")
        self.presentedRecording = recording

        hetDeviceManager.disconnectCurrentDevice()
        masterVC.isDisabled = true
        
        let deviceType = HETDeviceType(rawValue: recording.deviceType)!
        
        chartManager.setupGraphView(for: deviceType, frameView: detailVC.chartsFrame)
        detailVC.setMode(mode: .file)
        
        presentedRecordingPackets = recordingManager.make(packetArrayFrom: recording)
        
        for packet in presentedRecordingPackets {
            chartManager.graph(packet: packet)
        }
        
        masterVC.isDisabled = false
    }
}

extension SplitViewController: ChartViewDelegate {
    func chartViewDidRequestExport() {
        exportManager.beginExporting(packetArray: presentedRecordingPackets, associatedRecording: presentedRecording, completion: { (url) in
            let documentPicker = UIDocumentPickerViewController(url: url, in: UIDocumentPickerMode.exportToService)
            self.present(documentPicker, animated: true, completion: nil)
        })
    }
    
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

extension SplitViewController: RecordingManagerDelegate {
    func recordingManagerDidSaveRecording() {
        masterVC.tableView.reloadData()
    }
}
