//
//  ApiClient.swift
//  ExerciseBlockchain
//
//  Created by liuhao on 14/12/2020.
//

import UIKit

class ApiClient: NSObject {
    
    static let shared = ApiClient.init()
    private let baseUrl = "https://api.blockchain.info/charts/market-price"
    private var cacheDict = [String: NetData]()
}

extension ApiClient {
    
    func getBlockchainData(timespan: EnumCommon.TimeSpan ,callBack: @escaping (NetData?) -> Void) ->Void {
        
        let urlStr = "\(baseUrl)?timespan=\(timespan.key)"
        
        // 字典缓存中有数据则取缓存
        if (cacheDict[urlStr] != nil ) {
            
            let cacheChartModels = cacheDict[urlStr]
            callBack(cacheChartModels)
        }else{
            guard let url = URL(string: urlStr) else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let data = data {
                    if let chartModels = try? JSONDecoder().decode(NetData.self, from: data){
                        
                        if chartModels.values.count > 0 {
                            
                            self.cacheDict[urlStr] = chartModels
                            callBack(chartModels)
                        }
                    }else{
                        callBack(nil)
                    }
                }else{
                    callBack(nil)
                }
            }.resume()
        }
    }
}
