//
//  FirstTableViewController.swift
//  NoName
//
//  Created by GiriNesia on 30/05/18.
//  Copyright © 2018 GiriNesia. All rights reserved.
//

import UIKit
import  CoreData
import UserNotifications
import NightNight

class FirstTableViewController: UITableViewController,  UNUserNotificationCenterDelegate, UISearchBarDelegate{
    
    var selectedTitle: String?
    var selectedDescription: String?
    var tasks = [Tasks]()
    var listTasks = List()
    var id: NSManagedObjectID?
    var tgl:Date?
    
    @IBOutlet weak var searchTasks: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchTasks.delegate = self
        loadTheme()
        notif()
        fetchData()
        UNUserNotificationCenter.current().delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func notif(){
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
            //print(error)
            //print(granted)
        })
        UNUserNotificationCenter.current().delegate = self
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //print(listTasks.prority.count)
        return listTasks.prority.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch listTasks.prority[section] {
        case "High Priority":
            return "High Priority"
        case "Medium Priority":
            return "Medium Priority"
        case "Low Priority":
            return "Low Priority"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch listTasks.prority[section] {
        case "High Priority":
            return listTasks.height.count
        case "Medium Priority":
            return listTasks.med.count
        case "Low Priority":
            return listTasks.low.count
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierCell", for: indexPath) as! FirstTableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        if listTasks.prority[indexPath.section] == "High Priority"{
            //print(listTasks.height[indexPath.row].title!)
            cell.titleTask.text = listTasks.height[indexPath.row].title
            cell.date.text = formatter.string(from: listTasks.height[indexPath.row].time! as Date)
        }
        if listTasks.prority[indexPath.section] == "Medium Priority"{
            cell.titleTask.text = listTasks.med[indexPath.row].title
            cell.date.text = formatter.string(from: listTasks.med[indexPath.row].time! as Date)
        }
        if listTasks.prority[indexPath.section] == "Low Priority"{
            cell.titleTask.text = listTasks.low[indexPath.row].title
            cell.date.text = formatter.string(from: listTasks.low[indexPath.row].time! as Date)
        }
        cell.mixedBackgroundColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
        return cell
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        fetchData()
        tableView.reloadData()
        
        //print("GG")
    }
   

    
    // Override to support editing the table view.
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let alert = UIAlertController(title: "Delete", message: "Are You Sure Delete This Tasks?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                if self.listTasks.prority[indexPath.section] == "High Priority"{
                    self.deleteTable(delete:  self.listTasks.height[indexPath.row].objectID)
                    //listTasks.height.remove(at: indexPath.row)
                }
                else if self.listTasks.prority[indexPath.section] == "Medium Priority"{
                    self.deleteTable(delete:  self.listTasks.med[indexPath.row].objectID)
                    //listTasks.med.remove(at: indexPath.row)
                }
                else if self.listTasks.prority[indexPath.section] == "Low Priority"{
                    self.deleteTable(delete:  self.listTasks.low[indexPath.row].objectID)
                    //listTasks.low.remove(at: indexPath.row)
                }
                self.fetchData()
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        delete.backgroundColor = .red
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let Edit = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                if self.listTasks.prority[indexPath.section] == "High Priority"{
                    self.id = self.listTasks.height[indexPath.row].objectID
                    self.tgl = self.listTasks.height[indexPath.row].time! as Date
                }
                else if self.listTasks.prority[indexPath.section] == "Medium Priority"{
                    self.id = self.listTasks.med[indexPath.row].objectID
                    self.tgl = self.listTasks.med[indexPath.row].time! as Date
                }
                else if self.listTasks.prority[indexPath.section] == "Low Priority"{
                    self.id = self.listTasks.low[indexPath.row].objectID
                    self.tgl = self.listTasks.low[indexPath.row].time! as Date
                }
                self.performSegue(withIdentifier: "editTasks", sender: self)
            })
        
            Edit.backgroundColor = .purple
        
            
            return UISwipeActionsConfiguration(actions: [Edit])
        
    }
    
    
    func deleteTable(delete: NSManagedObjectID){
        do{
            let item = try context.existingObject(with: delete) as! Tasks
                    context.delete(item)
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id!])
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
        
        }catch {
            
        }
        searchTasks.text = ""
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listTasks.prority[indexPath.section] == "High Priority"{
            id = listTasks.height[indexPath.row].objectID
        }
        else if listTasks.prority[indexPath.section] == "Medium Priority"{
            id = listTasks.med[indexPath.row].objectID
        }
        else if listTasks.prority[indexPath.section] == "Low Priority"{
             id = listTasks.low[indexPath.row].objectID
        }
        self.performSegue(withIdentifier: "shwoDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shwoDetail" {
            let des = segue.destination as! DetailViewController
            des.id = id
        }
        else if segue.identifier == "editTasks" {
            let des = segue.destination as! NewTaskController
            des.editID = id
            des.editTask = true
            des.dueDate = tgl!
        }
        
    }
    
    
    @IBAction func prepareForTask(segue: UIStoryboardSegue) {
        self.tabBarController?.tabBar.isHidden = false
        fetchData()
        tableView.reloadData()
    }
    
    func fetchData(){
        do {
            remove()
            tasks = try context.fetch(Tasks.fetchRequest())
            for load in tasks {
                if load.status == false{
                    let date =  Double((load.time?.timeIntervalSinceNow)!)
                    if date < 0 {
                        load.status = true
                        appDelegate.saveContext()
                        //print("Lewat 0")
                    }
                    else if date < 864000 && date > 0  {
                        listTasks.height.append(load)
                    } else if  date > 864000 && date <  1728000 {
                        listTasks.med.append(load)
                    } else if date > 1728000{
                        listTasks.low.append(load)
                    }
                }
            }
            if listTasks.height.isEmpty == false{
                listTasks.prority.append("High Priority")
            }
            if listTasks.med.isEmpty == false{
                listTasks.prority.append("Medium Priority")
            }
            if listTasks.low.isEmpty == false{
                listTasks.prority.append("Low Priority")
            }
            } catch {
            
        }
    }
    func remove(){
        listTasks.height.removeAll()
        listTasks.prority.removeAll()
        listTasks.low.removeAll()
        listTasks.med.removeAll()
    }
    
    @objc func applicationDidBecomeActive() {
        // handle event
        fetchData()
        tableView.reloadData()
        //print("GGGG")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "title contains[c] '\(searchText)'")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Tasks")
            fetchRequest.predicate = predicate
            do {
                tasks = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject] as! [Tasks]
                searchData()
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }else {
            fetchData()
        }
        tableView.reloadData()
    }
    
    func searchData(){
        do {
             remove()
            for load in tasks {
                if load.status == false{
                    let date =  Double((load.time?.timeIntervalSinceNow)!)
                    if date < 0 {
                        load.status = true
                        appDelegate.saveContext()
                        //print("Lewat 0")
                    }
                    else if date < 864000 && date > 0  {
                        listTasks.height.append(load)
                    } else if  date > 864000 && date <  1728000 {
                        listTasks.med.append(load)
                    } else if date > 1728000{
                        listTasks.low.append(load)
                    }
                }
            }
            if listTasks.height.isEmpty == false{
                listTasks.prority.append("High Priority")
            }
            if listTasks.med.isEmpty == false{
                listTasks.prority.append("Medium Priority")
            }
            if listTasks.low.isEmpty == false{
                listTasks.prority.append("Low Priority")
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
        tabBarController?.tabBar.mixedBarTintColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
        view.mixedBackgroundColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
    }
    
    @objc func dismissKeyboard() {
        self.searchTasks.endEditing(true)
    }
}
