//
//  AppReviewGraph.swift
//  AppReviewTime
//
//  Created by Timothy Barnard on 20/06/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa
import  Charts

class AppReviewGraph: NSView {
    
    var lineChartView: LineChartView?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let frameRect = NSRect(x: 10, y: 10, width: self.frame.width - 10, height: self.frame.height - 10 )
        
        if self.lineChartView == nil {
            self.lineChartView = LineChartView(frame: frameRect)
            self.addSubview(self.lineChartView!)
        } else {
            self.lineChartView?.removeFromSuperview()
            self.lineChartView = LineChartView(frame: frameRect)
            self.addSubview(self.lineChartView!)
        }
        lineChartView?.chartDescription!.text = "Review"
    }
    
    func createLineChart() {
        
        let frameRect = NSRect(x: 10, y: 10, width: self.frame.width - 10, height: self.frame.height - 10 )
        
        if self.lineChartView == nil {
            self.lineChartView = LineChartView(frame: frameRect)
            self.addSubview(self.lineChartView!)
        } else {
            self.lineChartView?.removeFromSuperview()
            self.lineChartView = LineChartView(frame: frameRect)
            self.addSubview(self.lineChartView!)
        }
        lineChartView?.chartDescription!.text = "Review"
    }
    
    func setChart(_ label: String, values: [[Review]]) {
        
        var yValues : [ChartDataEntry] = [ChartDataEntry]()
        
        for (i, reviewArr) in values.enumerated() {
            
            var total = 0
            for(_, review) in reviewArr.enumerated() {
                total = total + review.dayCount
            }
            
            let average = total / reviewArr.count
            
            yValues.append(ChartDataEntry(x: Double(i + 1), y: Double(average)))
        }
        
        let data = LineChartData()
        let ds = LineChartDataSet(values: yValues, label: label)
        
        data.addDataSet(ds)
        self.lineChartView!.data = data
    }
}
