//
//  questionaireResponse.swift
//  riskassessment
//
//  Created by Annie Yin on 7/17/17.
//  Copyright © 2017 Annie Yin. All rights reserved.
//

import Foundation

struct measurement {
    fileprivate var units: unitMeasures
    fileprivate var value: Double
    fileprivate var type: heightOrWeight
    
    init(recordedUnits: unitMeasures, recordedValue: Double, recordedType: heightOrWeight) {
        self.units = recordedUnits
        self.value = recordedValue
        self.type = recordedType
    }
    
    func convertWeight() -> Double {
        switch units {
        case .imperial:
            let returnValue = round(value*0.454*100)/100
            return returnValue
        case .metric:
            let returnValue = round(value*2.205*100)/100
            return returnValue
        }
    }
    
    func convertHeight() -> Double {
        switch units {
        case .imperial:
            let returnValue = round(value*0.394*100)/100
            return returnValue
        case .metric:
            let returnValue = round(value*2.54*100)/100
            return returnValue
        }
    }
    
    func getWeight(_ requestedUnits: unitMeasures) -> Double {
        if units.rawValue == requestedUnits.rawValue {
            return value
        } else {
            return convertWeight()
        }
    }
    
    func getHeight(_ requestedUnits: unitMeasures) -> Double {
        if units.rawValue == requestedUnits.rawValue {
            return value
        } else {
            return convertHeight()
        }
    }
    
    func getMeasurement(_ requestedUnits: unitMeasures) -> Double {
        switch type {
        case .Height:
            return getHeight(requestedUnits)
        case .Weight:
            return getWeight(requestedUnits)
        }
    }
    
    func getHeightDefault(_ units: unitMeasures) -> Double {
        switch units {
        case .imperial:
            return 67
        case .metric:
            return 170
        }
    }
}

class questionaireResponse {
    var uniqueID: String
    var name: String
    var sex: Int
    var smoker: Int
    var heightValue: Double
    var weightValue: Double
    var unitSystem: Int
    var birthDate: String
    
    init(enteredName: String, enteredSex: Int, enteredSmoker: Int, enteredHeight: Double, enteredWeight: Double, units: Int, enteredBirthDate: String) {
        self.uniqueID = enteredName
        self.name = enteredName
        self.sex = enteredSex
        self.smoker = enteredSmoker
        self.heightValue = enteredHeight
        self.weightValue = enteredWeight
        self.unitSystem = units
        self.birthDate = enteredBirthDate
    }
    
    func buildJSONstring(_ response: questionaireResponse) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let JSON = "{\"name\":\"\(response.name)\", \"sex\":\"\(response.sex)\", \"smoker\":\"\(response.smoker)\", \"units\":\"\(response.unitSystem)\", \"birthdate\":\"\(response.birthDate)\", \"id\":\"\(response.uniqueID)\"}"
        
        return JSON
    }
    
    func JSONtoQuestionaireResponse(_ JSON: NSDictionary) -> questionaireResponse? {
        let name = String(JSON["name"] as! NSString)
        let sex = String(JSON["sex"] as! NSString)
        let smoker = String(JSON["smoker"] as! NSString)
        let height = String(JSON["height"] as! NSString)
        let weight = String(JSON["weight"] as! NSString)
        let units = String(JSON["units"] as! NSString)
        let birthDate = String(JSON["birthdate"] as! NSString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return questionaireResponse(enteredName: name, enteredSex: Int(sex)!, enteredSmoker: Int(smoker)!, enteredHeight: Double(height)!, enteredWeight: Double(weight)!, units: Int(units)!, enteredBirthDate: birthDate)
    }
    
    func writeToFile(_ filePath: String) -> [questionaireResponse] {
        var pastResponses: [questionaireResponse] = []
        
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = URL(fileURLWithPath: dir).appendingPathComponent(filePath)
            
            do {
                var jsonString = "{\"subjects\":["
                let JSONarray = readFromFile(filePath)
                for entry in 0..<JSONarray.count {
                    let subject = JSONarray[entry] as! NSDictionary
                    if String(subject["id"] as! NSString) != self.uniqueID {
                        pastResponses.append(JSONtoQuestionaireResponse(subject)!)
                    }
                }
                jsonString = jsonString + buildJSONstring(self)
                for response in pastResponses {
                    jsonString = jsonString + ", " + buildJSONstring(response)
                }
                jsonString = jsonString + "]}"
                try jsonString.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                pastResponses.append(self)
            }
            catch {}
        }
        return pastResponses
    }
}



























