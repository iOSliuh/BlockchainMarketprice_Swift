//
//  ApiClient.swift
//  ExerciseBlockchain
//
//  Created by liuhao on 14/12/2020.
//

import UIKit
import Alamofire

class ApiClient: NSObject {
    static let shared = ApiClient.init()
    
    private let baseUrl = "https://api.blockchain.info/charts/market-price"
}

extension ApiClient {
    
    func getBlockchainData(timespan: EnumCommon.TimeSpan ,callBack: @escaping (ChartModel?) -> Void) ->Void {
        
        AF.request(baseUrl,parameters: ["timespan": timespan.key]).responseString { (response) in
            
            if response.error == nil {
                if let chartModel = ChartModel.deserialize(from: response.value){
                
                    callBack(chartModel)
    
                }else{
                    callBack(nil)
                }
            }else{
                callBack(nil)
            }
        }
    }
}
