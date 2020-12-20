//
//  MarketPriceChartView.swift
//  ExerciseBlockchain
//
//  Created by liuhao on 18/12/2020.
//

import UIKit
import SwiftCharts

class MarketPriceChartView: UIView {
    
    public var chart: Chart?
    public var currentPositionLabels: [UILabel] = []
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
     init(frame: CGRect,chartModel: NetData) {
        
        super.init(frame: frame)
        
        initChart(frame: frame, marketPriceData: chartModel)
    }
    
    private func initChart(frame: CGRect, marketPriceData: NetData) {
        
        let readFormatter = DateFormatter()
        readFormatter.dateFormat = "MM dd,yyyy"
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "d MMM yy"
        
        let  labelSettings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 10))

        var chartPoints: [ChartPoint] = []
        marketPriceData.values.forEach {(value) in
            
            let date = Date.init(timeIntervalSince1970: TimeInterval(value.x))
            let charPoint = ChartPoint(
                x: transferDate(date, displayFormatter: displayFormatter),
                y: ChartAxisValueDouble(value.y)
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
            let chartValue_MaxY = marketPriceData.values.max { (chartValue1, chartValue2) -> Bool in
                return chartValue1.y < chartValue2.y
            }
            let chartValue_MinY = marketPriceData.values.min { (chartValue1, chartValue2) -> Bool in
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
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: marketPriceData.unit, settings:labelSettings.defaultVertical()))
        let chartSettings = ChartSettingDefaults.chartSettingsWithPanZoom
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: frame, xModel: xModel, yModel: yModel)
        
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
                
                label.center = CGPoint(x: chartPointWithScreenLoc.screenLoc.x  , y: chartPointWithScreenLoc.screenLoc.y - label.frame.height*2)
                label.backgroundColor = .init(red: 14/255, green: 81/255, blue: 239/255, alpha: 1.0)
                label.textColor = UIColor.white
                label.font = UIFont.systemFont(ofSize: 14)
                label.textAlignment = .center
                self.currentPositionLabels.append(label)
                
                let label_date = UILabel()
                let dateString = String(closeChartPoint.x.description)
                
                label_date.text = dateString
                label_date.sizeToFit()
                label_date.center = CGPoint(x: chartPointWithScreenLoc.screenLoc.x , y: chartPointWithScreenLoc.screenLoc.y + label.frame.height)
               
                label_date.backgroundColor = UIColor.white
                label_date.textColor = .gray
                label_date.textAlignment = .center
                label_date.font = UIFont.systemFont(ofSize: 14)
                self.currentPositionLabels.append(label_date)
                
                self.addSubview(label)
                self.addSubview(label_date)
            }
        }
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.systemPink,linesWidth: 0.1)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height
        ), innerFrame: innerFrame, settings: chartSettings, layers: [xAxisLayer,yAxisLayer,guidelinesLayer,chartPointsLineLayer,chartPointsTrackerLayer
            ]
        )
        self.addSubview(chart.view)
        self.chart = chart
    }
}

func transferDate(_ date: Date, displayFormatter: DateFormatter) -> ChartAxisValue {
    let labelSettings_date = ChartLabelSettings(font: UIFont.boldSystemFont(ofSize: 11),fontColor: .darkGray, rotation: 45, rotationKeep: .top)

    return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings_date)
}
