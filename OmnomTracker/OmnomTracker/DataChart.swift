//
//  DataChart.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 8/11/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import Foundation

struct ChartData {
    let name: String
    let popularity: Double
}

class DataChartStore {
    class func generate() -> [ChartData] {
        return [
            ChartData(name: "Java", popularity: 30232),
            ChartData(name: "C#", popularity: 12355),
            ChartData(name: "C", popularity: 3494),
            ChartData(name: "C++", popularity: 4930)
        ]
    }
}
