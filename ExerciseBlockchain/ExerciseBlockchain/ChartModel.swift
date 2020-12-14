//
//  ChartModel.swift
//  BitcoinGraph
//
//  Created by liuhao on 10/12/2020.
//

import UIKit
import HandyJSON

class ChartModel: HandyJSON {
    
    var status: String!
    var name: String!
    var unit: String!
    var perios: String!
    var description: String!
    var values: [ChartValue]!
    
    required init(){
        
    }
}

class ChartValue: HandyJSON {
    var x: Double = 0
    var y: Double = 0
    
    required init(){
        
    }
}
