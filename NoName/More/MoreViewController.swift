//
//  MoreViewController.swift
//  NoName
//
//  Created by giri on 6/23/18.
//  Copyright © 2018 Bianka. All rights reserved.
//

import UIKit
import NightNight

class MoreViewController: UIViewController {

    @IBOutlet weak var txtmode: UILabel!
    @IBOutlet weak var night: UISwitch!
    
    @IBAction func tellFriend(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["Gunakan Aplikasi Kita"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func mode(_ sender: UISwitch) {
        if night.isOn {
            NightNight.theme = .night
            UserDefaults.standard.set(true, forKey: "theme")
        }else {
            NightNight.theme = .normal
            UserDefaults.standard.set(false, forKey: "theme")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
    }
    
    func load(){
        let theme = UserDefaults.standard.bool(forKey: "theme")
        if theme {
            NightNight.theme = .night
            night.setOn(theme, animated: true)
        } else {
            NightNight.theme = .normal
            night.setOn(theme, animated: true)
        }
        
        self.navigationController?.navigationBar.mixedBarTintColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
        
         navigationController?.navigationBar.mixedTitleTextAttributes = [NNForegroundColorAttributeName: MixedColor(normal: UIColor.black, night: UIColor.white)]

        
        tabBarController?.tabBar.mixedBarTintColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
        
            view.mixedBackgroundColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
        
        txtmode.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
