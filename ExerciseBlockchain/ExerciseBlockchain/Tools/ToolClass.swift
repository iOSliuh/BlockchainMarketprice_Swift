//
//  ToolClass.swift
//  ExerciseBlockchain
//
//  Created by liuhao on 18/12/2020.
//

import UIKit

class ToolClass {

}

extension Double {
 
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
