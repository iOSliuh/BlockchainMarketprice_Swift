//
//  EnumCommon.swift
//  BitcoinGraph
//
//  Created by liuhao on 10/12/2020.
//

import UIKit

class EnumCommon: NSObject {

}

extension EnumCommon {
    enum TimeSpan: String, CaseIterable {
        case thirty_Days = "30 Days"
        case sixty_Days = "60 Days"
        case oneHundredEighty_Days = "180 Days"
        case one_Year = "1 Year"
        case three_Years = "3 Years"
        case all_time = "All Time"
        
        var key: String {
            switch self {
            case .thirty_Days: return "30days"
            case .sixty_Days: return "60days"
            case .oneHundredEighty_Days: return "180days"
            case .one_Year: return "1year"
            case .three_Years: return "2years"
            case .all_time: return "all"
            }
        }
    }
}


