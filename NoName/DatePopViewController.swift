//
//  DatePopViewController.swift
//  NoName
//
//  Created by giri on 6/13/18.
//  Copyright © 2018 Bianka. All rights reserved.
//

import UIKit

class DatePopViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var formateDate: Date {
        return datePicker.date
    }
    
    @IBOutlet var back: UIView!
    @IBOutlet weak var dateSelect: UIView!
    @IBOutlet weak var titleDate: UILabel!
    
    
    @objc func backAction(_ sender:UITapGestureRecognizer){
        // do other task
        //print("Succses")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BackFromDate"), object: self)
        dismiss(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureMenu = UITapGestureRecognizer(target: self, action:  #selector(self.backAction))
        self.back.addGestureRecognizer(gestureMenu)
        dateSelect.layer.cornerRadius = 6
        titleDate.layer.cornerRadius = 6

                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SaveDate(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myDate"), object: self)
        dismiss(animated: true)
    }
    
    
}
