//
//  ViewController.swift
//  ExerciseBlockchain
//
//  Created by liuhao on 14/12/2020.
//

import UIKit
import SwiftCharts

class ViewController: UIViewController {
    
    let isLiuhaiScreen = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
    
    var chart: Chart?
    var currentPositionLabels: [UILabel] = []
    
    private var didLayout: Bool = false
    
    private var timespan: EnumCommon.TimeSpan = .thirty_Days  {
        didSet{
            if timespan != oldValue {
                
                DispatchQueue.main.async {
                    
                    if self.chart != nil {
                        self.chart!.view.removeFromSuperview()
                        
                        self.currentPositionLabels.forEach { (label) in
                            label.removeFromSuperview()
                        }
                    }
                    self.drawGraph()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
       
        self.drawGraph()
        self.createSegmentControl()
    }
    
    @objc func segmentedDidChange(segmented:UISegmentedControl) {
        
        self.timespan = EnumCommon.TimeSpan.allCases[segmented.selectedSegmentIndex]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.didLayout == false {
            self.didLayout = true
        }
    }

}

extension ViewController {
    private func drawGraph() -> Void {
        ApiClient.shared.getBlockchainData(timespan: timespan,callBack:{(chartModel) in
            
            DispatchQueue.main.async {
                
                if chartModel == nil{
                    self.title = "Network Error"
                }else {
                    self.initChart(chartModel!)
                    self.title = chartModel!.name
                }
            }
        }
      )
    }
    
    private func createSegmentControl() -> Void {
        let durationSegmentControl = UISegmentedControl()
        for (index,timeSpan) in  EnumCommon.TimeSpan.allCases.enumerated() {
            durationSegmentControl.insertSegment(withTitle: timeSpan.rawValue, at: index, animated: true)
        }
        
        let bottom_h = isLiuhaiScreen ? 34:0
        let left_w = isLiuhaiScreen ? 44:20
        durationSegmentControl.frame = CGRect(x: left_w, y: (Int(UIScreen.main.bounds.size.height) - bottom_h - 35), width: 420, height: 31)
        durationSegmentControl.tintColor = .init(red: 134/255, green: 143/255, blue: 162/255, alpha: 1.0)
        durationSegmentControl.selectedSegmentTintColor = .init(red: 174/255, green: 210/255, blue: 251/255, alpha: 1.0)
        durationSegmentControl.selectedSegmentIndex = 0
        durationSegmentControl.addTarget(self, action: #selector(segmentedDidChange), for: UIControl.Event.valueChanged)
        self.view.addSubview(durationSegmentControl)
    }
    
    private func  initChart(_ chartModel:  ChartModel) {
        
        let readFormatter = DateFormatter()
        readFormatter.dateFormat = "MM dd,yyyy"
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "d MMM yy"
        
        let  labelSettings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 11))

        var chartPoints: [ChartPoint] = []
        chartModel.values.forEach {(chartValue) in
            
            let date = Date.init(timeIntervalSince1970: TimeInterval(chartValue.x))
            let charPoint = ChartPoint(
                x: transferDate(date, displayFormatter: displayFormatter),
                y: ChartAxisValueDouble(chartValue.y)
            )
            chartPoints.append(charPoint)
        }
    
        let xValues: [ChartAxisValue] = {
            
            var tempArray: [ChartAxisValue] = []
            
            // 横轴分5个区间
            let unit = chartPoints.count / 6
            
            for index in 0 ..< 6 {
                let charAxisValue = chartPoints[index * unit].x
                tempArray.append(charAxisValue)
            }
            return tempArray
        }()
        
        let yValues: [ChartAxisValue] = {
            
            var tempArray: [ChartAxisValue] = []
            let chartValue_MaxY = chartModel.values.max { (chartValue1, chartValue2) -> Bool in
                return chartValue1.y < chartValue2.y
            }
            let chartValue_MinY = chartModel.values.min { (chartValue1, chartValue2) -> Bool in
                return chartValue1.y < chartValue2.y
            }
            
            let range = Int(chartValue_MinY!.y) / 1000 ... Int(chartValue_MaxY!.y) / 1000 + 1
            
            for index in range {
                let axisValue = ChartAxisValue.init(scalar: Double(index * 1000))
               
                tempArray.append(axisValue)
            }
            return tempArray
        }()
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Date", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: chartModel.name, settings:labelSettings.defaultVertical()))
                                                                                            
        let chartFrame:CGRect
        
        if UIApplication.shared.windows[0].safeAreaInsets.bottom > 0 {

            chartFrame = CGRect(x: 44 - 5, y: 10, width: UIScreen.main.bounds.size.width - 44 + 5, height: UIScreen.main.bounds.size.height - 34 - 35 - 10)
        }else{
            chartFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 35)
        }
    
        let chartSettings = ChartSettingDefaults.chartSettingsWithPanZoom
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer,coordsSpace.yAxisLayer,coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: .init(red: 14/255, green: 81/255, blue: 239/255, alpha: 1.0), animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel], useView: false)
        
        let thumbSettings = ChartPointsLineTrackerLayerThumbSettings(thumbSize:10,thumbBorderWidth: 2)
        let trackerLayerSettings = ChartPointsLineTrackerLayerSettings(thumbSettings: thumbSettings)
        
        let chartPointsTrackerLayer = ChartPointsLineTrackerLayer<ChartPoint,Any>(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lines: [chartPoints], lineColor: .init(red: 14/255, green: 81/255, blue: 239/255, alpha: 1.0), animDuration: 1, animDelay: 2, settings: trackerLayerSettings){chartPointsWithScreenLoc in
                
            self.currentPositionLabels.forEach{$0.removeFromSuperview()}
            
            for(_, chartPointWithScreenLoc) in chartPointsWithScreenLoc.enumerated(){
                
                let chartPoint = chartPointWithScreenLoc.chartPoint
                
                let xScalar = chartPoint.x.scalar
                let closeChartPoint: ChartPoint = {
                    
                    for index in 0 ..< chartPoints.count {
                        let chartPoint = chartPoints[index]
                        
                        if xScalar <= chartPoint.x.scalar {
                            return chartPoint
                        }
                    }
                    return chartPoints.last!
                }()
                
                let label = UILabel()
                label.text = String(closeChartPoint.y.scalar.roundTo(places: 2))
                
                label.sizeToFit()
                
                label.center = CGPoint(x: chartPointWithScreenLoc.screenLoc.x + label.bounds.size.width/2 , y: chartPointWithScreenLoc.screenLoc.y + chartFrame.minY - label.bounds.size.height / 2)

                label.backgroundColor = .init(red: 14/255, green: 81/255, blue: 239/255, alpha: 1.0)
                label.textColor = UIColor.white
                
                self.currentPositionLabels.append(label)
                
                let label_date = UILabel()
                let dateString = String(closeChartPoint.x.description)
                
                label_date.text = dateString
                label_date.sizeToFit()
                label_date.center = CGPoint(x: chartPointWithScreenLoc.screenLoc.x + label.bounds.size.width/2, y: chartFrame.height - 45 - label_date.bounds.size.height)
                label_date.backgroundColor = UIColor.white
                label_date.textColor = .gray
                self.currentPositionLabels.append(label_date)
                
                self.view.addSubview(label)
                self.view .addSubview(label_date)
            }
        }
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.systemPink,linesWidth: 0.1)
        
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        let chart = Chart(frame: chartFrame, innerFrame: innerFrame, settings: chartSettings, layers: [xAxisLayer,yAxisLayer,guidelinesLayer,chartPointsLineLayer,chartPointsTrackerLayer
            ]
        )
        view.addSubview(chart.view)
        self.chart = chart
    }
}

func transferDate(_ date: Date, displayFormatter: DateFormatter) -> ChartAxisValue {
    let labelSettings = ChartLabelSettings(font: UIFont.boldSystemFont(ofSize: 11),fontColor: .darkGray, rotation: 0, rotationKeep: .top)

    return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
}

extension Double {
 
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


