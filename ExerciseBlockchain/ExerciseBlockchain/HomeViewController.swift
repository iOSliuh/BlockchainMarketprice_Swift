//
//  ViewController.swift
//  ExerciseBlockchain
//
//  Created by liuhao on 14/12/2020.
//

import UIKit

class HomeViewController: UIViewController,ChartDurationSelectionsViewProtocol {
    
    let gapTop = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0 ? 44:20

    var marketPriceChartView: MarketPriceChartView?
        
    private var timespan: EnumCommon.TimeSpan = .thirtyDays  {
        didSet{
            if timespan != oldValue {
                
                DispatchQueue.main.async {
                    
                    if self.marketPriceChartView?.chart != nil {
                        
                        self.marketPriceChartView?.chart!.view.removeFromSuperview()
                        self.marketPriceChartView?.currentPositionLabels.forEach { (label) in
                            
                             label.removeFromSuperview()
                        }
                    }
                    self.drawGraph()
                }
            }
        }
    }
    
    func durationSegmentControlClicked(index: Int) {
        
        self.timespan = EnumCommon.TimeSpan.allCases[index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
       
        self.drawGraph()
        self.addSegmentControl()
        self.addTitleView()
    }
}

extension HomeViewController {
    private func drawGraph() -> Void {
        ApiClient.shared.getBlockchainData(timespan: timespan,callBack:{(chartModel) in
            
            DispatchQueue.main.async {
                
                if chartModel == nil{
                     
                    // Todo need to show error
                }else {
                    
                    self.addMarketPriceView(chartModel!)
                }
            }
        }
      )
    }
    
    private func addTitleView() -> Void {
        let titleView = HeaderTitleView(frame: CGRect(x: 0, y: self.gapTop, width: Int(UIScreen.main.bounds.width), height: 100))
        self.view.addSubview(titleView)
    }
    
    private func addMarketPriceView(_ chartModel: NetData) {
        
        let chartFrame = CGRect(x: 0, y: (gapTop + 100) , width: Int(UIScreen.main.bounds.size.width), height: 400)
        let chartView = MarketPriceChartView(frame: chartFrame, chartModel: chartModel)
       
        self.view.addSubview(chartView)
        self.marketPriceChartView = chartView
    }
    
    private func addSegmentControl() -> Void {
       
        let durationSelectionsView = ChartDurationSelectionsView(frame: CGRect(x: 10, y: (gapTop + 100 + 400 + 30), width: Int(UIScreen.main.bounds.size.width) - 20, height: 31))
        durationSelectionsView.delegate = self
        
        for (index,timeSpan) in  EnumCommon.TimeSpan.allCases.enumerated() {
            durationSelectionsView.durationSegmentControl.insertSegment(withTitle: timeSpan.rawValue, at: index, animated: true)
        }
        durationSelectionsView.durationSegmentControl.selectedSegmentIndex = 0
        self.view.addSubview(durationSelectionsView)
    }
}
