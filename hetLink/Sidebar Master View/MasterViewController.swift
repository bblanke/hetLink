//
//  MasterViewController.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/13/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import CoreBluetooth

class MasterViewController: UITableViewController {

    var hetDevices : [CBPeripheral] = []
    var deviceListDelegate : DeviceListDelegate!

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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hetDevices.count > 0 ? hetDevices.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        
        if hetDevices.count > 0 {
            cell.textLabel?.text = hetDevices[indexPath.row].name
        } else {
            cell.textLabel?.text = "No devices found"
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

