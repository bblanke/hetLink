//
//  DetailViewController.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/13/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController{
    
    @IBOutlet weak var chartsFrame: UIView!
    
    var chartDelegate: ChartViewDelegate!
    
    var visibilityMenuController: DatasetVisibilityViewController!
    var visibilityBarItem: UIBarButtonItem!
    
    var chartManager: ChartManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Theme.detailNavigationBarBackground
        self.navigationController?.navigationBar.tintColor = Theme.navigationBarTint
        
        self.view.backgroundColor = Theme.graphViewBackground
        
        print("charts frame: \(chartsFrame.hashValue)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setMode(mode: GraphMode){
        setupButtons(charts: chartManager.chartViews, mode: mode)
    }
    
    func setupButtons(charts: [HETChartView], mode: GraphMode){
        var buttonArray: [UIBarButtonItem] = []
        
        visibilityBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "visible"), style: .plain, target: self, action: #selector(showGraphToggleMenu))
        buttonArray.append(visibilityBarItem)
        
        if mode == .device {
            // Set up Record button
            let recordButton = ToggleBarButtonItem(image: #imageLiteral(resourceName: "record"), style: .plain, target: self, action: #selector(toggleRecording))
            recordButton.selectedColor = UIColor.flatRed
            recordButton.deselectedColor = UIColor.flatWhite
            buttonArray.append(recordButton)
        }
        
        if mode == .file {
            let exportButton = UIBarButtonItem(image: #imageLiteral(resourceName: "export"), style: .plain, target: self, action: #selector(beginExport))
            buttonArray.append(exportButton)
        }
        
        self.navigationItem.rightBarButtonItems = buttonArray
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        visibilityMenuController = storyboard.instantiateViewController(withIdentifier: "DatasetToggleViewController") as! DatasetVisibilityViewController
        visibilityMenuController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        visibilityMenuController.charts = charts
    }
    
    func showGraphToggleMenu(sender: UIButton){
        self.present(visibilityMenuController, animated: true, completion: nil)
    }
    
    func toggleRecording(sender: ToggleBarButtonItem){
        sender.toggleSelected()
        chartDelegate.chartView(didToggle: sender.isSelected)
    }
    
    func beginExport(sender: UIButton){
        chartDelegate.chartViewDidRequestExport()
    }
}

enum GraphMode {
    case device, file
}

