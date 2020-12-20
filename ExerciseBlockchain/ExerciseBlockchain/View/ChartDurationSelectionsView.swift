//
//  ChartDurationSelectionsView.swift
//  ExerciseBlockchain
//
//  Created by liuhao on 18/12/2020.
//

import UIKit
protocol ChartDurationSelectionsViewProtocol:NSObjectProtocol {
    func durationSegmentControlClicked(index: Int)
}

class ChartDurationSelectionsView: UIView {
    
    weak var delegate: ChartDurationSelectionsViewProtocol?
    public let durationSegmentControl: UISegmentedControl = {
        
        let segmentControl = UISegmentedControl()
        segmentControl.backgroundColor = .white
        segmentControl.tintColor = .init(red: 134/255, green: 143/255, blue: 162/255, alpha: 1.0)
        segmentControl.selectedSegmentTintColor = .init(red: 174/255, green: 210/255, blue: 251/255, alpha: 1.0)
    
        let dic = [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 10)];
        segmentControl.setTitleTextAttributes(dic as [NSAttributedString.Key : Any], for: UIControl.State.normal);
        segmentControl.addTarget(self, action: #selector(segmentedDidChange), for: UIControl.Event.valueChanged)
    
        return segmentControl
    }()
    
    @objc func segmentedDidChange(segmented:UISegmentedControl) {
        
        self.delegate?.durationSegmentControlClicked(index: segmented.selectedSegmentIndex)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.durationSegmentControl.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(durationSegmentControl)
    }
}




