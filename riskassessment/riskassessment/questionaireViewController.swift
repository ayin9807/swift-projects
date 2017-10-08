//
//  questionaireViewController.swift
//  riskassessment
//
//  Created by Annie Yin on 7/17/17.
//  Copyright © 2017 Annie Yin. All rights reserved.
//

import UIKit

class questionaireViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        weightLabel.text = unitModel.getSettings().getUnitDescription(heightOrWeight.Weight)
        heightValue = measurement(recordedUnits: unitModel.getSettings(), recordedValue: heightValue.getHeightDefault(unitModel.getSettings()), recordedType: heightOrWeight.Height)
        heightLabel.text = "\(heightValue.getMeasurement(unitModel.getSettings())) \(unitModel.getSettings().getUnitDescription(heightOrWeight.Height))"
    }
    
    let unitModel = ApplicationSettings()
    var weightValue = measurement(recordedUnits: unitMeasures(rawValue: 1)!, recordedValue: 0, recordedType: heightOrWeight.Weight)
    
    var heightValue = measurement(recordedUnits: unitMeasures(rawValue: 1)!, recordedValue: 0, recordedType: heightOrWeight.Height)
    
    let filePath = "storage.json"
    var questionArray: [questionaireResponse] = []
    var currentResponse: questionaireResponse?
    
    var submit = false {
        didSet {
            submit = false
            performSegue(withIdentifier: "submitSegue", sender: nameTextField)
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sexSelection: UISegmentedControl!
    @IBOutlet weak var smokingSwitch: UISwitch!
    @IBOutlet weak var heightSelector: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightEntryField: UITextField!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var birthDateSelection: UIDatePicker!
    
    @IBAction func editName(_ sender: UITextField) {
        sender.backgroundColor = UIColor.lightGray
    }
    
    func setWeight() {
        if let userEntered = weightEntryField.text {
            if let weight = Double(userEntered) {
                weightValue = measurement(recordedUnits: unitModel.getSettings(), recordedValue: weight, recordedType: heightOrWeight.Weight)
            }
        }
    }

    @IBAction func heightSlideAction(_ sender: UISlider) {
        let height = round(Double(sender.value)*heightValue.getHeightDefault(unitModel.getSettings())*200)/100
        heightValue = measurement(recordedUnits: unitModel.getSettings(), recordedValue: height, recordedType: heightOrWeight.Height)
        heightLabel.text = "\(heightValue.getMeasurement(unitModel.getSettings())) \(unitModel.getSettings().getUnitDescription(heightOrWeight.Height))"
    }
    
    @IBAction func submitAnswers(_ sender: UIButton) {
        
    }
    
    // Abort Segue
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if identifier == "submitSegue" {
            setWeight()
            let name = nameTextField.text
            let weight = weightValue.getMeasurement(unitModel.getSettings())
            if name == "" {
                nameTextField.backgroundColor = UIColor.red
                return false
            }
            if weight < 30 || weight > 700 {
                weightEntryField.backgroundColor = UIColor.red
                return false
            }
        }
        return true
    }
    
    // Pickerview Code
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return pickerModel.getDimensions()
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerModel.getSelections().count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerModel.getSelections()[row]
//    }
//    
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        // Popover should not take over entire screen
//        return UIModalPresentationStyle.none
//    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        // If we exit a popover update data on QuestionaireVC
        weightLabel.text = unitModel.getSettings().getUnitDescription(heightOrWeight.Weight)
        weightEntryField.text = String(weightValue.getMeasurement(unitModel.getSettings()))
        heightLabel.text = "\(String(heightValue.getMeasurement(unitModel.getSettings()))) \(unitModel.getSettings().getUnitDescription(heightOrWeight.Height))"
        heightLabel.sizeToFit()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? settingsViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "settingsSegue":
                        if let ppc = vc.popoverPresentationController {
                            ppc.permittedArrowDirections = UIPopoverArrowDirection.any
                            ppc.delegate = self
                            
                            setWeight()
                        }
                    default:
                        break
                }
            }
        }
        
        if let vc = segue.destination as? resultsViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "submitSegue":
                        setWeight()
                        // save data
                        let name = nameTextField.text
                        let sex = sexSelection.selectedSegmentIndex
                        let smoker = smokingSwitch.isOn ? 1:0
                        let height = heightValue.getMeasurement(unitModel.getSettings())
                        let weight = weightValue.getMeasurement(unitModel.getSettings())
                        let birthDate = DateFormatter.localizedString(from: birthDateSelection.date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.full)
                        let responses = questionaireResponse(enteredName: name!, enteredSex: sex, enteredSmoker: smoker, enteredHeight: height, enteredWeight: weight, units: unitModel.getSettings().rawValue, enteredBirthDate: birthDate)
                        currentResponse = responses
                        questionArray = responses.writeToFile(filePath)
                    
                        vc.questionArray = self.questionArray
                        vc.currentResponse = self.currentResponse
                    default:
                        break
                    
                }
            }
            
        }
    }

}









