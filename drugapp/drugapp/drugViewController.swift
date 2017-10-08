//
//  drugViewController.swift
//  drugapp
//
//  Created by Annie Yin on 7/6/17.
//  Copyright © 2017 Annie Yin. All rights reserved.
//

import UIKit

class drugViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {
    
    fileprivate let drugDataModel = drugModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        drugTableView.delegate = self
        drugTableView.dataSource = self
        webReferenceView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var drugTableView: UITableView!
    
    @IBOutlet weak var webReferenceView: UIWebView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugDataModel.getImages().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if (tableView == drugTableView) {
            let cellIdentifier = "imageCell"
            let testCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            if testCell == nil {
                let drug = drugDataModel.getDrug()
                cell.textLabel?.text = drug
                cell.textLabel?.numberOfLines = 2
                cell.imageView?.image = UIImage.init(named: drugDataModel.getImages()[drug]!)
                cell.imageView?.sizeToFit()
                return cell
            }
            else {
                let drug = drugDataModel.getDrug()
                testCell!.textLabel?.text = drug
                testCell!.textLabel?.numberOfLines = 2
                testCell!.imageView?.image = UIImage.init(named: drugDataModel.getImages()[drug]!)
                testCell!.imageView?.sizeToFit()
                return testCell!
            }
        }
        return cell

    }
    
    var drugList: [String] = []
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        let selectedCell = tableView.cellForRow(at: didSelectRowAt)!
        let selectedDrug = selectedCell.textLabel?.text!
        if !drugList.contains(selectedDrug!) {
            drugList.append(selectedDrug!)
        }
        
        if selectedDrug != nil {
            if selectedDrug == "Potassium Cyanide" {
                let alert = UIAlertController(title: "WARNING!", message: "Potassium Cyanide is know to be hazardous to human health. Please stop taking immediately!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Meh", style: UIAlertActionStyle.default, handler: nil))
                let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 75, height: 75))
                imageView.image = UIImage.init(named: "poison")
                alert.view.addSubview(imageView)
                self.present(alert, animated: true, completion: nil)
                
            }
            let url = URL.init(string: drugDataModel.getURLs()[selectedDrug!]!)
            let urlRequest = URLRequest.init(url: url!)
            webReferenceView.isHidden = false
            webReferenceView.loadRequest(urlRequest)
        }
        
//        let alert = UIAlertController(title: "Confirm meds", message: "The following meds were selected as active: \n" + alertText, preferredStyle: UIAlertControllerStyle.actionSheet)
//        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.destructive)
//            { (action: UIAlertAction) -> Void in
//                if drugList.count > 0 {
//                    
//                }
//            }
//        )
//
//        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addToPillbox(_ sender: UIButton) {
        let alertText = drugList.joined(separator: ", ")
        let alert = UIAlertController(title: "Confirm meds", message: "The following meds were selected as active: \n" + alertText, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Nevermind", style: UIAlertActionStyle.destructive)
            { (action: UIAlertAction) -> Void in
                if self.drugList.count > 0 {
                    self.drugList.removeAll()
                }
            }
        )
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetPillbox(_ sender: UIButton) {
        
    }

}
