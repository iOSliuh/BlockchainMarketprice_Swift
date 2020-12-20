//
//  EnumCommon.swift
//  BitcoinGraph
//
//  Created by liuhao on 10/12/2020.
//

import UIKit

class EnumCommon {

}

extension EnumCommon {
    enum TimeSpan: String, CaseIterable {
        case thirtyDays = "30 Days"
        case sixtyDays = "60 Days"
        case oneHundredEightyDays = "180 Days"
        case oneYear = "1 Year"
        case threeYears = "3 Years"
        case allTime = "All Time"
        
        var key: String {
            switch self {
            case .thirtyDays: return "30days"
            case .sixtyDays: return "60days"
            case .oneHundredEightyDays: return "180days"
            case .oneYear: return "1year"
            case .threeYears: return "2years"
            case .allTime: return "all"
            }
        }
    }
}


