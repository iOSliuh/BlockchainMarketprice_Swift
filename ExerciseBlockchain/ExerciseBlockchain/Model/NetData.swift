//
//  MarketPricePointListModel.swift
//  ExerciseBlockchain
//
//  Created by liuhao on 17/12/2020.
//

import Foundation

struct NetData: Codable {
    
    var status: String!
    var name: String!
    var unit: String!
    var perios: String!
    var description: String!
    var values: [Point]!
}

struct Point: Codable {
    
    var x: Int
    var y: Double
}
