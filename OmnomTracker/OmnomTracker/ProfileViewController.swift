//
//  ProfileViewController.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 10/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit
import SwiftCharts

class ProfileViewController: UIViewController {
    @IBOutlet weak var chart: ShinobiChart!
    
    var logRepo = LogRepository()
    //var resultLogs = [Float]()

    var logData: [(item: String, massa: Float)] = []
    
    func setupChart() {
        let resultLogs = logRepo.getAllLogs()
        var count = 1
        for log in resultLogs {
            logData.append((item: String(count), massa: Float(log)))
            count = count + 1
        }
        
        chart.backgroundColor = .clear
        
        // Create chart axes
        let xAxis = SChartCategoryAxis()
        chart.xAxis = xAxis
        
        let yAxis = SChartNumberAxis()
        yAxis.title = "Weight"
        yAxis.rangePaddingLow = 1 - resultLogs.min()!
        yAxis.rangePaddingHigh = 1
        chart.yAxis = yAxis
        
        // This controller will provide the data to the chart
        chart.datasource = self
        
        view.addSubview(chart)
    }

    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChart()
        // Do any additional setup after loading the view.
        let repo = UserRepository()
        user = repo.get()
        print(user.profilePicUrl)
        print(user.gender)
        print(user.calorieGoal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }

}

// MARK:- SChartDatasource Functions
extension ProfileViewController: SChartDatasource {
    
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 1
    }
    
    // Create column series object
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        let series = SChartColumnSeries()
        
        // Configure column colors for positive and negative Y values
        series.style().showAreaWithGradient = false
        
        // Display labels for each column
        series.style().dataPointLabelStyle.showLabels = false
        
        // Position labels slightly above data point on y axis
        series.style().dataPointLabelStyle.offsetFromDataPoint = CGPoint(x: 0, y: -15)
        
        // Label should contain just the y value of each data point
        series.style().dataPointLabelStyle.displayValues = .Y
        
        series.style().dataPointLabelStyle.textColor = .black
        
        return series
    }
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        return logData.count
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        let xValue = logData[dataIndex].item
        let yValue = logData[dataIndex].massa
        return SChartDataPoint(xValue:xValue, yValue:yValue)
    }
}

// MARK:- SChartDelegate Functions
extension ProfileViewController: SChartDelegate {
    
    func sChart(_ chart: ShinobiChart, alter label: SChartDataPointLabel, for dataPoint: SChartDataPoint, in series: SChartSeries) {

        label.font = .boldSystemFont(ofSize: 13)
        
        let center = label.center
        // Resize label to fit increased font size
        label.sizeToFit()
        // Recenter label
        label.center = center
    }
}

