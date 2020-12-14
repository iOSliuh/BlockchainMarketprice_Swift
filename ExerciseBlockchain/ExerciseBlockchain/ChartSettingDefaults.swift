//
//  ChartSettingDefaults.swift
//  ExerciseBlockchain
//
//  Created by liuhao on 14/12/2020.
//

import UIKit
import SwiftCharts


struct ChartSettingDefaults {
    
    static func chartFrame(_ containerBounds: CGRect) -> CGRect {
      
        return CGRect(x: 5, y: 10, width: containerBounds.size.width - 5, height: containerBounds.size.height - 10)
    }
    
    static var chartSettingsWithPanZoom: ChartSettings {
        var chartSettings = normalChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        
        return chartSettings
    }
    
    fileprivate static var normalChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        
        return chartSettings
    }
    
}
