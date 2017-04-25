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
        createYearTestLogs()

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
        let weekDates = getWeekDates()
        let weekLogs = getLogsForDates(dates: weekDates)
        var hoursCommitted: [Double] = []
        
        for log in weekLogs {
            hoursCommitted.append(log.totalHours)
        }
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<weekDates.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(hoursCommitted[i]))
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
        for date in weekDates {
            prettyDateStrings.append(date.prettyString)
        }

        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: prettyDateStrings)
        lineChartView.xAxis.granularity = Double((daysInWeek - 1) / 2)
        
        /* Plot chart */
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.animate(yAxisDuration: 1.2)
    }
    
    func plotMonth() {

        /* Get data */
        let monthDates = getMonthDates()
        let monthLogs = getLogsForDates(dates: monthDates)
        var hoursCommitted: [Double] = []

        for log in monthLogs {
            hoursCommitted.append(log.totalHours)
        }

        var dataEntries: [ChartDataEntry] = []
        for i in 0..<monthDates.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(hoursCommitted[i]))
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
        for date in monthDates {
            prettyDateStrings.append(date.prettyString)
        }

        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: prettyDateStrings)
        lineChartView.xAxis.granularity = Double((daysInMonth - 1) / 2)
        
        /* Plot chart */
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.animate(yAxisDuration: 1.2)
    }
    
    func plotYear() {
        var avgHoursCommitted: [Double] = []
        var monthLabels: [String] = []
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: date)
        let formatter = DateFormatter()
        let months = formatter.shortMonthSymbols!
        
        var month = components.month!
        var year = components.year!
        
        for _ in 0..<monthsInYear {
            if (month == 0) {
                month = 12
                year -= 1
            }
            
            let avg = getAvgHoursForMonth(year: year, month: month)
            avgHoursCommitted.append(avg)
            monthLabels.append(months[month - 1])
            month -= 1
        }
        
        /* Flip labels and values to have most recent things on right */
        avgHoursCommitted = avgHoursCommitted.reversed()
        monthLabels = monthLabels.reversed()
        
        /* Set up x-axis labels */
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthLabels)
        lineChartView.xAxis.granularity = Double(2)
        
        /* Create data set */
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<monthsInYear {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(avgHoursCommitted[i]))
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
        
        /* Plot chart */
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.animate(yAxisDuration: 1.2)
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
            plotYear()
            break
        default:
            break
        }
    }
    
}
