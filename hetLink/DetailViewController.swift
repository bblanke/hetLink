//
//  DetailViewController.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/13/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var chartView: HETChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChart()
        
        print("detail VC is getting initialized \(self.hashValue)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addChart() {
        chartView = HETChestBodyChartView(frame: view.bounds)
        
        self.view.addSubview(chartView as! UIView)
    }
}

