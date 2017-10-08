//
//  drugModel.swift
//  drugapp
//
//  Created by Annie Yin on 7/6/17.
//  Copyright © 2017 Annie Yin. All rights reserved.
//

import Foundation

private func loadArray(_ textPathName: String) -> (imageDict: [String:String], referenceDict: [String:String], drugList: [String]) {
    
    var fileArray = [String]()
    var imageDict: [String:String] = [:]
    var referenceDict: [String:String] = [:]
    var drugList: [String] = []
    let myBundle = Bundle.main
    var textContent = String?("")
    
    if let localPath = myBundle.path(forResource: textPathName, ofType: "csv") {
        do {
            textContent = try NSString(contentsOfFile: localPath, usedEncoding: nil) as String
        } catch {
            print ("Datasource read error for \(textPathName)")
        }
    } else {
        
    }
    
    fileArray = textContent!.components(separatedBy: "\r")
    var skipHeader = true
    for row in fileArray {
        if skipHeader {
            skipHeader = false
        } else {
            let rowArray = row.components(separatedBy: ",")
            let drug = rowArray[0]
            let drugImage = rowArray[1]
            let drugUrl = rowArray[2]
            imageDict[drug] = drugImage
            referenceDict[drug] = drugUrl
            drugList.append(drug)
        }
    }
    
    return (imageDict, referenceDict, drugList)
}

class drugModel {
    fileprivate let fileName = "drugAppData"
    fileprivate var imageDict: [String:String]
    fileprivate var referenceDict: [String:String]
    fileprivate var fullDrugList: [String]
    fileprivate var tempDrugList: [String]
    
    init() {
        let trouple = loadArray(fileName)
        imageDict = trouple.imageDict
        referenceDict = trouple.referenceDict
        fullDrugList = trouple.drugList
        tempDrugList = trouple.drugList
    }
    
    func getImages() -> [String:String] {
        return imageDict
    }
    
    func getURLs() -> [String:String] {
        return referenceDict
    }
    
    func getDrug() -> String {
        if tempDrugList.count == 0 {
            tempDrugList = fullDrugList
            return tempDrugList.popLast()!
        }
        return tempDrugList.popLast()!
    }
}
