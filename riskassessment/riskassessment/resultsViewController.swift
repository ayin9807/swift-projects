//
//  resultsViewController.swift
//  riskassessment
//
//  Created by Annie Yin on 7/17/17.
//  Copyright © 2017 Annie Yin. All rights reserved.
//

import UIKit

class resultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var questionArray: [questionaireResponse] = []
    var currentResponse: questionaireResponse?
    var risk: riskLevels?

    override func viewDidLoad() {
        super.viewDidLoad()
        risk = calculateRisk(currentResponse!)
        riskImage.image = UIImage.init(named: risk!.getImage())
        riskLabel.text = risk!.getName()
        riskDescription.text = risk!.getDescription()
        previousTableView.delegate = self
        previousTableView.dataSource = self
    }
    
    @IBOutlet weak var riskImage: UIImageView!
    @IBOutlet weak var riskLabel: UILabel!
    @IBOutlet weak var riskDescription: UITextView!
    
    @IBOutlet weak var previousTableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if (tableView == previousTableView) {
            let cellIdentifier = "previousExampleCell"
            let testCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            if testCell == nil {
                cell.textLabel?.text = questionArray[indexPath.row].name + " " + questionArray[indexPath.row].birthDate
                cell.textLabel?.numberOfLines = 2
                return cell
            } else {
                testCell!.textLabel?.text = questionArray[indexPath.row].name + " " + questionArray[indexPath.row].birthDate
                testCell?.textLabel?.numberOfLines = 2
                return testCell!
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        _ = tableView.cellForRow(at: indexPath as IndexPath)!
    }
}
