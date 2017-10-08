//
//  settingsViewController.swift
//  riskassessment
//
//  Created by Annie Yin on 7/17/17.
//  Copyright © 2017 Annie Yin. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {
    var settingModel = ApplicationSettings()

    override func viewDidLoad() {
        super.viewDidLoad()
        unitSelector.selectedSegmentIndex = settingModel.getSettings().rawValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var unitSelector: UISegmentedControl!
    
    @IBAction func chooseUnits(_ sender: UISegmentedControl) {
        settingModel.saveSettings(unitMeasures(rawValue: sender.selectedSegmentIndex)!)
    }
    

}
