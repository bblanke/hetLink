//
//  HETChartView.swift
//  hetLink
//
//  Created by Bailey Blankenship on 6/20/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import Charts

protocol HETChartView: class {
    var chartDataSets: [LineChartDataSet]! { get }
    
    func graph(packet: HETPacket)
}
