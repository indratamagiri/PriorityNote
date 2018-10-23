//
//  DetailViewController.swift
//  NoName
//
//  Created by giri on 6/12/18.
//  Copyright © 2018 Bianka. All rights reserved.
//

import UIKit
import CoreData
import NightNight

class DetailViewController: UIViewController {
    var id: NSManagedObjectID?
    var task = [Tasks]()
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var desTxt: UILabel!
    @IBOutlet weak var titleTxt: UILabel!
    
    @IBOutlet weak var lbltext: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        self.tabBarController?.tabBar.isHidden = true
        loadTheme()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load(){
        do{
            do {
                let managedObject = try context.existingObject(with: id!) as! Tasks
                    titleTxt.text = managedObject.title
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    date.text = formatter.string(from: managedObject.time! as Date)
                    desTxt.text = managedObject.des
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.userInfo)")
            }
        
        }
    }
    
    func loadTheme(){
        let theme = UserDefaults.standard.bool(forKey: "theme")
        if theme {
        NightNight.theme = .night
        } else {
        NightNight.theme = .normal
        }
        self.navigationController?.navigationBar.mixedBarTintColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
        
        navigationController?.navigationBar.mixedTitleTextAttributes = [NNForegroundColorAttributeName: MixedColor(normal: UIColor.black, night: UIColor.white)]
        
        view.mixedBackgroundColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
        date.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
        desTxt.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
        titleTxt.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
        lblDes.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
        lbltext.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)


    }

}
