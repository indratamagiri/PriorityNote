//
//  CompletedTableViewController.swift
//  NoName
//
//  Created by GiriNesia on 30/05/18.
//  Copyright © 2018 GiriNesia. All rights reserved.
//

import UIKit
import CoreData
import NightNight

class CompletedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

   var id: NSManagedObjectID?
    var compleated = [Tasks]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        fetchdata()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchdata()
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        loadTheme()
    }
    
    @objc func dismissKeyboard() {
          self.searchBar.endEditing(true)
    }
    
    func fetchdata(){
        do {
            compleated.removeAll()
            var tasks = [Tasks]()
            tasks =  try context.fetch(Tasks.fetchRequest())
            for task in tasks {
                if task.status == true{
                    compleated.append(task)
                }
                //print(compleated)
            }
        } catch  let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return compleated.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Completedtasks", for: indexPath) as! CompletedTableViewCell
        if compleated.isEmpty == false {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                cell.titleTask.text = compleated[indexPath.row].title
                cell.dateTask.text = formatter.string(from: compleated[indexPath.row].time! as Date)
                cell.mixedBackgroundColor = MixedColor(normal: UIColor(red: 240/255, green: 166/255, blue: 137/255, alpha: 1.0), night: UIColor(red:0.31, green:0.38, blue:0.44, alpha:1.0))
        }
            return cell
    }
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let alert = UIAlertController(title: "Delete", message: "Are You Sure Delete This Tasks?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                
                self.deleteTable(delete: self.compleated[indexPath.row].objectID)
                self.compleated.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
               
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        delete.backgroundColor = .red
        return [delete]
    }
    
    
    func deleteTable(delete: NSManagedObjectID){
        do{
            let item = try context.existingObject(with: delete) as! Tasks
            context.delete(item)
           
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }catch {
            
        }
        searchBar.text = ""
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         id = compleated[indexPath.row].objectID
        self.performSegue(withIdentifier: "showDetailUncompleted", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailUncompleted" {
            let des = segue.destination as! DetailViewController
            des.id = id
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if !searchText.isEmpty {
            compleated.removeAll()
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "title contains[c] '\(searchText)'")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Tasks")
            fetchRequest.predicate = predicate
            do {
                var searchTask = [Tasks]()
                searchTask = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject] as! [Tasks]
                for data in searchTask {
                        if data.status == true{
                            compleated.append(data)
                        }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }else {
            fetchdata()
        }
        tableView.reloadData()
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
}
