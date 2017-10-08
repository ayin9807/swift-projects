//
//  ApplicationSettings.swift
//  riskassessment
//
//  Created by Annie Yin on 7/17/17.
//  Copyright © 2017 Annie Yin. All rights reserved.
//

import Foundation

enum heightOrWeight: String {
    case Height
    case Weight
}

enum unitMeasures: Int {
    case imperial = 0
    case metric = 1
    
    func getUnitDescription(_ type: heightOrWeight) -> String {
        switch type {
        case .Height:
            switch self {
            case .imperial:
                return "in"
            case .metric:
                return "cm"
            }
        case .Weight:
            switch self {
            case .imperial:
                return "lbs"
            case .metric:
                return "kg"
            }
        }
    }
}

class ApplicationSettings {
    fileprivate let defaults = UserDefaults.standard
    fileprivate let keyValue = "units"
    
    func getSettings() -> unitMeasures {
        let rawValue = (defaults.object(forKey: keyValue) as? NSNumber)
        var rawVal = 0
        if rawValue != nil {
            rawVal = Int(rawValue!)
        }
        return (unitMeasures.init(rawValue: rawVal))!
    }
    
    func saveSettings(_ unit: unitMeasures) {
        defaults.set(unit.rawValue, forKey: keyValue)
    }
}
