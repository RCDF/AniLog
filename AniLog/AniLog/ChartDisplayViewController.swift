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
        
        /* TESTING: REMOVE BEFORE DEPLOYMENT */
        createWeekTestLogs()

        initializeChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        plotWeek()
    }
    
    func initializeChart() {
        lineChartView.noDataText = "There is no data to plot."
        lineChartView.noDataTextColor = UIColor.goldenYellow

        lineChartView.delegate = self
        lineChartView.isUserInteractionEnabled = true
        
        lineChartView.xAxis.labelFont = NSUIFont(name: "HelveticaNeue", size: 11.5)!
        lineChartView.xAxis.axisLineColor = UIColor.peach
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        
        lineChartView.getAxis(.left).labelFont = NSUIFont(name: "HelveticaNeue", size: 11.5)!
        lineChartView.getAxis(.left).axisLineColor = UIColor.peach
        lineChartView.getAxis(.left).axisMinimum = 0
        lineChartView.getAxis(.left).drawAxisLineEnabled = false
        lineChartView.getAxis(.right).enabled = false
        
        lineChartView.chartDescription?.text = ""
        
        lineChartView.scaleYEnabled = false
        lineChartView.highlightPerDragEnabled = false
        
        lineChartView.legend.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelTextColor = UIColor.peach
        lineChartView.leftAxis.labelTextColor = UIColor.peach
        lineChartView.leftAxis.gridColor = UIColor.peach.withAlphaComponent(0.4)
        // lineChartView.xAxis.labelRotationAngle = -90
    }

    func plotWeek() {
        
        /* Get data */
        let dateStrings = getWeekDateStrings()
        let weekLogs = getLogsFromStrings(dateStrings: dateStrings)
        var minutesCommitted: [Double] = []
        
        for log in weekLogs {
            minutesCommitted.append(log.totalHours)
        }
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dateStrings.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(minutesCommitted[i]))
            dataEntries.append(dataEntry)
        }

        /* Set up data set */
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Hours committed")
        lineChartDataSet.setColor(UIColor.peach)
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.lineWidth = 1.5

        /* Create gradient fill layer */
        let gradientColors = [UIColor.peach.cgColor, UIColor.white.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        lineChartDataSet.drawFilledEnabled = true

        /* Set up x-axis labels */
        var prettyDateStrings: [String] = []
//        for i in 0...2 {
//            prettyDateStrings.append(dateStringPretty(dateStrings[i * 3]))
//        }
        for string in dateStrings {
            prettyDateStrings.append(dateStringPretty(string))
        }

        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: prettyDateStrings)
        lineChartView.xAxis.granularity = 3.0
        
        /* Plot chart */
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.animate(yAxisDuration: 1.2)
    }
    
    func plotMonth() {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [17.3, 17.0, 10.0, 7.0, 3.0, 3.0, 3.0, 2.0, 1.0, 6.0, 3.0, 13.0]
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<months.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: unitsSold[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Units sold")
        lineChartDataSet.setColor(UIColor.peach)
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.lineWidth = 1.5
        
        let gradientColors = [UIColor.peach.cgColor, UIColor.white.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        lineChartDataSet.drawFilledEnabled = true // Draw the Gradient
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)

    }

    @IBAction func willChangeRange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // day
            break
        case 1:
            // week
            plotWeek()
            break
        case 2:
            // month
            plotMonth()
            break
        case 3:
            // year
            break
        default:
            break
        }
    }
    
}
