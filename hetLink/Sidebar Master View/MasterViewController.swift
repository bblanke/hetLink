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
        return hetDevices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        
        cell.textLabel?.text = hetDevices[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deviceListDelegate.deviceList(didSelect: hetDevices[indexPath.row])
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

