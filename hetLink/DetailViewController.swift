//
//  DetailViewController.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/13/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var chartsFrame: UIView!
    @IBOutlet weak var chartButtonbar: UIToolbar!
    
    var chartViews: [HETChartView] = []
    
    var currentDeviceType: HETDeviceType!
    
    var chartDelegate: ChartViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupGraphs(for device: HETDevice){
        chartViews = []
        switch device.type! {
        case .chest:
            let frames = createFrames(in: chartsFrame.frame, number: 2)
            chartViews.append(HETChestBodyChartView(frame: frames[0]))
            chartViews.append(HETChestAccelChartView(frame: frames[1]))
            
            setupButtons(charts: chartViews)
            break
        case .watch: break
        }
        
        for chartView in chartViews {
            self.view.addSubview(chartView as! UIView)
        }
        
        currentDeviceType = device.type
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
    
    private func setupButtons(charts: [HETChartView]){
        var buttonArray: [UIBarButtonItem] = []
        
        // Set up Record button
        let recordButton = ToggleButton(title: "Record", color: UIColor.red)
        recordButton.isSelected = false
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        let recordBarItem = UIBarButtonItem(customView: recordButton)
        buttonArray.append(recordBarItem)
        
        // Add flexible space
        buttonArray.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        
        // Add the buttons to toggle all of the datasets
        for chart in charts {
            for set in chart.chartDataSets {
                let button = DatasetToggleButton(title: set.label!, color: set.colors.first!, dataset: set, chart: chart)
                
                let barButtonItem = UIBarButtonItem(customView: button)
                buttonArray.append(barButtonItem)
            }
        }
        
        chartButtonbar.setItems(buttonArray, animated: true)
    }
    
    func toggleRecording(sender: UIButton){
        chartDelegate.chartView(didToggleRecording: sender.isSelected)
    }
}

