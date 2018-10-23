//
//  ViewController.swift
//  NoName
//
//  Created by Bianka Aristania on 30/05/18.
//  Copyright © 2018 Bianka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var titleText: String?
    var descriptionText: String?
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = titleText
        labelDescription.text = descriptionText
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

