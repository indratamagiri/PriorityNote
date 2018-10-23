//
//  NewTaskController.swift
//  NoName
//
//  Created by Bianka Aristania on 30/05/18.
//  Copyright © 2018 Bianka. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
import NightNight

class NewTaskController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lbldue: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    
    var dueDate:Date = Date()
    var id: String?
    var editID: NSManagedObjectID?
    var editTask:Bool = false
    
    @IBAction func actionDone(_ sender: Any) {
        if txtTitle.text != "" && txtDescription.text != ""{
            if dueDate.timeIntervalSinceNow > 30 {
                if (editTask){
                    do {
                        let save = try context.existingObject(with: editID!) as! Tasks
                        //print(managedObject)
                        save.id = id
                        save.status = false
                        save.des = txtDescription.text
                        save.title = txtTitle.text
                        save.time = dueDate as NSDate
                        appDelegate.saveContext()
                        
                    }
                    catch {
                        let fetchError = error as NSError
                        print("\(fetchError), \(fetchError.userInfo)")
                    }
                }
                else {
                    indent()
                    saveData()
                    alertNotif()
                }
                //print(dueDate.date.timeIntervalSinceNow)
            performSegue(withIdentifier: "menuTask", sender: self)
                
            }else {
                let alert = UIAlertController(title: "Alert", message: "Time should more 10 minuts", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else {
            let alert = UIAlertController(title: "Alert", message: "Input Title and Descroption", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alertNotif(){
        
        let action1 = UNNotificationAction(identifier: "Done", title: "Kelar", options: UNNotificationActionOptions.foreground)
        let action2 = UNNotificationAction(identifier: "Belum", title: "Belum Kelar", options: UNNotificationActionOptions.foreground)
        let category = UNNotificationCategory(identifier: id!,
                                              actions: [action1,action2],
                                              intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
            //set content
            let content = UNMutableNotificationContent()
            content.title = txtTitle.text!
            content.subtitle = "Timed Notification"
            content.body = txtDescription.text
            content.categoryIdentifier = id!
            
            //set trigger
            /*let trigger = UNTimeIntervalNotificationTrigger(
             timeInterval: 10.0,
             repeats: false)*/
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval:  dueDate.timeIntervalSinceNow,
                repeats: false)
        
            UNUserNotificationCenter.current().delegate = self
        //Create the request
            let request = UNNotificationRequest(
                identifier: id!,
                content: content,
                trigger: trigger
            )
            //Schedule the request
            UNUserNotificationCenter.current().add(
                request, withCompletionHandler: nil)
        }
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        pickDate()
        // Do any additional setup after loading the view.
        didEditTask()
        txtTitle.delegate = self as? UITextFieldDelegate
        txtDescription.delegate = self as? UITextViewDelegate
        load()
    }
    
    func pickDate() {
        NotificationCenter.default.addObserver(self, selector: #selector(handePopup), name: NSNotification.Name(rawValue: "myDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backFromPopup), name: NSNotification.Name(rawValue: "BackFromDate"), object: nil)
    }
    
    
    @objc func backFromPopup(notif: Notification){
        _ = notif.object as! DatePopViewController
        
        //print(dateVc.formateDate)
    }
    
    @objc func handePopup(notif: Notification){
        let dateVc = notif.object as! DatePopViewController
        dueDate = dateVc.formateDate
        datelbl.text = formatDate(Date: dueDate)
        //print(dateVc.formateDate)
    }
    
    func formatDate(Date: Date)->String {
        let format = DateFormatter()
        format.dateStyle = .full
        return format.string(from: Date)
    }
    
    func didEditTask(){
       
        if (editTask){
            do {
                self.navigationItem.title = "Edit Task"
                let managedObject = try context.existingObject(with: editID!) as! Tasks
                //print(managedObject)
                datelbl.text = formatDate(Date: managedObject.time! as Date)
                txtTitle.text = managedObject.title
                txtDescription.text = managedObject.des
                id = managedObject.id
            }
            catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.userInfo)")
            }
        }
    }
    
    
    
    
   
    
  
    
    func saveData(){
        let save = Tasks(context: context)
        save.id = id
        save.status = false
        save.des = txtDescription.text
        save.title = txtTitle.text
        save.time = dueDate as NSDate
        appDelegate.saveContext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func indent(){
        let number = Int(arc4random_uniform(100000))
        let iden = "TSK\(number)"
        //print(iden)
        fetchData(idPrimary: iden)
    }
    
    func fetchData(idPrimary: String){
        do {
            var loads = [Tasks]()
             loads = try context.fetch(Tasks.fetchRequest())
            for load in loads {
                if load.id == idPrimary {
                    indent()
                }
            }
            id = idPrimary
        } catch {
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtTitle {
            txtDescription.becomeFirstResponder()
        }else if textField == txtDescription {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func load(){
        let theme = UserDefaults.standard.bool(forKey: "theme")
        if theme {
            NightNight.theme = .night
        } else {
            NightNight.theme = .normal
        }
        self.navigationController?.navigationBar.mixedBarTintColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
        
        navigationController?.navigationBar.mixedTitleTextAttributes = [NNForegroundColorAttributeName: MixedColor(normal: UIColor.black, night: UIColor.white)]
        
        view.mixedBackgroundColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
        
        
        lblDes.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
        lbldue.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
        lbldate.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
        lblText.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
    }
   
   
}
