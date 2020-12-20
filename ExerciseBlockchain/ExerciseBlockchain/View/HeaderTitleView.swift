//
//  TitleView.swift
//  ExerciseBlockchain
//
//  Created by liuhao on 18/12/2020.
//

import UIKit

class HeaderTitleView: UIView {
    
    public let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 5, y: 10, width: UIScreen.main.bounds.width - 10, height: 35))
        label.text = "Market Price"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()
    
    public let subTitleLabel: UILabel = {
        let subLabel = UILabel(frame: CGRect(x: 5, y: 10 + 35 + 10, width: UIScreen.main.bounds.width - 10, height: 40))
        subLabel.text = "The average USD market price across major bitcoin exchanges."
        subLabel.textColor = .init(red: 85/255, green: 93/255, blue: 112/255, alpha: 1.0)
        subLabel.textAlignment = .center
        subLabel.font = UIFont.systemFont(ofSize: 14)
        subLabel.numberOfLines = 0
        subLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return subLabel
    }()
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
    }
}
