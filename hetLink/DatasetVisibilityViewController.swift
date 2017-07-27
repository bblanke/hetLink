//
//  DatasetVisibilityViewController.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/11/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import Charts

class DatasetVisibilityViewController: UITableViewController {

    var charts: [HETChartView] = [] {
        didSet {
            for chart in charts {
                datasets.append(contentsOf: chart.chartDataSets)
            }
            tableView.reloadData()
            preferredContentSize = CGSize(width: 300, height: CGFloat(44 * (datasets.count + 1)))
        }
    }
    private var datasets: [LineChartDataSet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return datasets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datasetToggleCell", for: indexPath) as! DatasetToggleViewCell

        cell.label.text = datasets[indexPath.row].label
        cell.toggleSwitch.onTintColor = datasets[indexPath.row].colors.first
        
        cell.dataset = datasets[indexPath.row]
        cell.charts = charts

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    @IBAction func didClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }    
}
