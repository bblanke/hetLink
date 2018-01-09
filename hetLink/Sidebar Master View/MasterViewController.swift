//
//  MasterViewController.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/13/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreData
import ChameleonFramework

class MasterViewController: UITableViewController {

    var hetDevices : [CBPeripheral] = []
    var masterListDelegate : MasterListDelegate!
    
    var recordingManager: RecordingManager!
    var isDisabled: Bool = false {
        didSet {
            tableView.alpha = isDisabled ? 0.5 : 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Theme.masterNavigationBarBackground
        self.navigationController?.navigationBar.tintColor = Theme.navigationBarTint
        self.view.backgroundColor = Theme.sourceBrowserBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return hetDevices.count > 0 ? hetDevices.count : 1
        case 1:
            return recordingManager.recordingCount
        default:
            fatalError("There is a section in the table view.")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! SourceBrowserCell
        
        if indexPath.section == 0 {
            if hetDevices.count > 0 {
                cell.titleLabel.text = hetDevices[indexPath.row].name
                cell.detailLabel.text = hetDevices[indexPath.row].identifier.uuidString
            } else {
                cell.titleLabel.text = "No devices found"
                cell.detailLabel.text = "Please switch on an HET device"
            }
        } else if indexPath.section == 1 {
            /*let record = recordingManager.recording(at: indexPath.row)
            cell.textLabel?.text = record.title
            let timestampParser = DateFormatter()
            timestampParser.timeStyle = .long
            timestampParser.dateStyle = .short
            cell.detailTextLabel?.text = timestampParser.string(from: record.timestamp! as Date)*/
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.section == 1 else { return false }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        recordingManager.delete(recording: recordingManager.recording(at: indexPath.row))
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isDisabled == false else { return }
        switch indexPath.section {
        case 0:
            guard hetDevices.count > 0 else { return }
            masterListDelegate.masterList(didSelectDevice: hetDevices[indexPath.row])
            break
        case 1:
            masterListDelegate.masterList(didSelectRecording: recordingManager.recording(at: indexPath.row))
            break
        default:
            fatalError("There is an extra section in the table view.")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Devices"
        case 1:
            return "Recordings"
        default:
            fatalError("There is an extra section in the table view.")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else { return }
        view.textLabel?.textColor = ContrastColorOf(Theme.sourceBrowserBackground, returnFlat: true)
    }
    
    
    // MARK: Functions for loading data
    
    func reloadHETDevices(devices: [CBPeripheral]){
        hetDevices = devices
        tableView.reloadData()
    }
    
}

protocol MasterListDelegate: class {
    func masterList(didSelectDevice device: CBPeripheral)
    func masterList(didSelectRecording recording: Recording)
}

