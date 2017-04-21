//
//  ChartDisplayViewController.swift
//  AniLog
//
//  Created by David Fang on 4/20/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit
import Charts

class ChartDisplayViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeChart()
        plotData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeChart() {
        lineChartView.noDataText = "There is no data to plot."
        lineChartView.noDataTextColor = UIColor.goldenYellow

        lineChartView.delegate = self
        lineChartView.isUserInteractionEnabled = true
        
        lineChartView.legend.enabled = false
        lineChartView.xAxis.labelFont = NSUIFont(name: "HelveticaNeue", size: 11.5)!
        lineChartView.xAxis.axisLineColor = UIColor.deepseaBlue
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        
        lineChartView.getAxis(.left).labelFont = NSUIFont(name: "HelveticaNeue", size: 11.5)!
        lineChartView.getAxis(.left).axisLineColor = UIColor.deepseaBlue
        lineChartView.getAxis(.left).axisMinimum = 0
        lineChartView.getAxis(.left).drawAxisLineEnabled = false
        lineChartView.getAxis(.right).enabled = false
        
        lineChartView.chartDescription?.text = ""
        
        lineChartView.scaleYEnabled = false
        lineChartView.highlightPerDragEnabled = false
    }

    func plotData() {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<months.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: unitsSold[i])
            dataEntries.append(dataEntry)
        }
        
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Units sold")
        lineChartDataSet.setColor(UIColor.deepseaBlue)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
        
        lineChartView.legend.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelTextColor = UIColor.deepseaBlue
        lineChartView.leftAxis.labelTextColor = UIColor.deepseaBlue
        lineChartView.leftAxis.gridColor = UIColor.deepseaBlue.withAlphaComponent(0.4)
    }
    
    
    
    
    @IBAction func willChangeRange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // day
            break
        case 1:
            // week
            break
        case 2:
            // month
            break
        case 3:
            // year
            break
        default:
            break
        }
    }
    
}
