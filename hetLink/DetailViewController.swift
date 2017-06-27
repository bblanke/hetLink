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
    
    var chartView: HETChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        addChart()
    }
    
    func addChart() {
        chartView = HETChestBodyChartView(frame: chartsFrame.frame)
        
        setupButtons(chart: chartView)
        
        self.view.addSubview(chartView as! UIView)
    }
    
    func setupButtons(chart: HETChartView){
        var buttonArray: [UIBarButtonItem] = []
        
        for set in chart.chartDataSets {
            let button = DatasetToggleButton(title: set.label!, color: set.colors.first!, dataset: set)
            
            let barButtonItem = UIBarButtonItem(customView: button)
            buttonArray.append(barButtonItem)
        }
        
        chartButtonbar.setItems(buttonArray, animated: true)
    }
}

