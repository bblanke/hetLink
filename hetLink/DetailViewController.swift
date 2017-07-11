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
    @IBOutlet weak var chartButtonbar: UIToolbar!
        
    var chartViews: [HETChartView] = []
    
    var currentDeviceType: HETDeviceType!
    
    var chartDelegate: ChartViewDelegate!
    
    var visibilityMenuController: DatasetVisibilityViewController!
    var visibilityBarItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupGraphs(for deviceType: HETDeviceType, mode: GraphMode){
        if chartViews.count > 0 {
            for chartView in chartViews{
                let view = chartView as! UIView
                view.removeFromSuperview()
            }
        }
        chartViews = []
        switch deviceType {
        case .chest:
            let frames = createFrames(in: chartsFrame.frame, number: 2)
            chartViews.append(HETChestBodyChartView(frame: frames[0]))
            chartViews.append(HETChestAccelChartView(frame: frames[1]))
            
            setupButtons(charts: chartViews, mode: mode)
            break
        case .watch: break
        }
        
        
        for chartView in chartViews {
            self.view.addSubview(chartView as! UIView)
        }
        
        currentDeviceType = deviceType
    }
    
    func graph(packet: HETPacket){
        switch currentDeviceType! {
        case .chest:
            switch packet.parser {
            case .ecgPulseOx:
                chartViews[0].graph(packet: packet)
                break
            case .battAccel:
                chartViews[1].graph(packet: packet)
                break
            }
            break
        case .watch:
            break
        }
    }
    
    private func createFrames(in frame: CGRect, number: Int) -> [CGRect]{
        let padding = 20
        let width: Int = Int(frame.width)
        let height: Int = (Int(frame.height) / number) - ((number - 1) * padding)
        
        let x: Int = Int(frame.minX)
        
        var frames: [CGRect] = []
        for i in 0..<number {
            let y: Int = Int(frame.minY) + height * i + padding * i
            frames.append(CGRect(x: x, y: y, width: width, height: height))
        }
        
        return frames
    }
    
    private func setupButtons(charts: [HETChartView], mode: GraphMode){
        /*var buttonArray: [UIBarButtonItem] = []
        
        /*if mode == .device {
            // Set up Record button
            let recordButton = ToggleButton(title: "Record", color: UIColor.red)
            recordButton.isSelected = false
            recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
            let recordBarItem = UIBarButtonItem(customView: recordButton)
            buttonArray.append(recordBarItem)
        }
        
        if mode == .file {
            // Set up Export button
            let exportButton = UIButton(type: .system)
            exportButton.setTitle("Export", for: .normal)
            exportButton.sizeToFit()
            exportButton.addTarget(self, action: #selector(beginExport), for: .touchUpInside)
            let exportBarItem = UIBarButtonItem(customView: exportButton)
            buttonArray.append(exportBarItem)
        }
            
        // Add flexible space
        buttonArray.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        
        // Add the buttons to toggle all of the datasets
        for chart in charts {
            for set in chart.chartDataSets {
                let button = DatasetToggleButton(title: set.label!, color: set.colors.first!, dataset: set, chart: chart)
                let barButtonItem = UIBarButtonItem(customView: button)
                buttonArray.append(barButtonItem)
            }
        }*/
        
        let visibilityButton = UIButton(type: .system)
        visibilityButton.setTitle("Toggle", for: .normal)
        visibilityButton.sizeToFit()
        visibilityButton.addTarget(self, action: #selector(showGraphToggleMenu), for: .touchUpInside)
        
        let visibilityBarItem = UIBarButtonItem(customView: visibilityButton)
        buttonArray.append(visibilityBarItem)
        
        chartButtonbar.setItems(buttonArray, animated: true)
        
        toggleAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        toggleAlertController.popoverPresentationController?.barButtonItem = visibilityBarItem
        
        for chart in charts {
            for set in chart.chartDataSets {
                let toggleAction = UIAlertAction(title: set.label!, style: .default, handler: nil)
                toggleAlertController.addAction(toggleAction)
            }
        }*/
        
        //self.navigationItem.rightBarButtonItem
        
        visibilityBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "visible"), style: .plain, target: self, action: #selector(showGraphToggleMenu))
        self.navigationItem.rightBarButtonItem = visibilityBarItem
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        visibilityMenuController = storyboard.instantiateViewController(withIdentifier: "DatasetToggleViewController") as! DatasetVisibilityViewController
        visibilityMenuController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        visibilityMenuController.charts = chartViews
    }
    
    func showGraphToggleMenu(sender: UIButton){
        self.present(visibilityMenuController, animated: true, completion: nil)
    }
    
    func toggleRecording(sender: UIButton){
        chartDelegate.chartView(didToggle: sender.isSelected)
    }
    
    func beginExport(sender: UIButton){
        chartDelegate.chartViewDidRequestExport()
    }
}

enum GraphMode {
    case device, file
}

