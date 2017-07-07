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

class MasterViewController: UITableViewController {

    var hetDevices : [CBPeripheral] = []
    var deviceListDelegate : DeviceListDelegate!
    
    var recordingsController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
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
            return (recordingsController.sections?.first?.numberOfObjects)!
        default:
            fatalError("There is a section in the table view that should not be present.")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        
        if indexPath.section == 0 {
            if hetDevices.count > 0 {
                cell.textLabel?.text = hetDevices[indexPath.row].name
                cell.detailTextLabel?.text = hetDevices[indexPath.row].identifier.uuidString
            } else {
                cell.textLabel?.text = "No devices found"
                cell.detailTextLabel?.text = "Please switch on an HET device"
            }
        } else if indexPath.section == 1 {
            let record = recordingsController.object(at: IndexPath(row: indexPath.row, section: 0)) as! Recording
            cell.textLabel?.text = record.title
            let timestampParser = DateFormatter()
            timestampParser.timeStyle = .long
            timestampParser.dateStyle = .short
            cell.detailTextLabel?.text = timestampParser.string(from: record.timestamp! as Date)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deviceListDelegate.deviceList(didSelect: hetDevices[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Devices"
        case 1:
            return "Recordings"
        default:
            return "Shouldn't be here"
        }
    }
    
    
    // MARK: Functions for loading data
    
    func reloadHETDevices(devices: [CBPeripheral]){
        hetDevices = devices
        tableView.reloadData()
    }
    
}

protocol DeviceListDelegate: class {
    func deviceList(didSelect device: CBPeripheral)
}

