//
//  TableViewController.swift
//  Todo-App
//
//  Created by Admin on 2/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController,  UISearchBarDelegate,UISearchDisplayDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var taskList = [TaskModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alwaysBounceVertical = true
        searchBar.delegate = self
        navigationItem.title = "Todo List"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort By", style: .plain, target: self, action: #selector(sortPressed))
        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "id")
        
        queryTasks()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            taskList.removeAll()
            let realm = try! Realm()
            let res = realm.objects(TaskModel.self).filter("toDo CONTAINS [c] %@",searchText)
            for elem in res{
                taskList.append(elem)
            }
            tableView.reloadData()
        }else{
            queryTasks()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
  
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete){
            removeFromMemory(task: taskList[indexPath.row])
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        
    }
    
    func removeFromMemory(task:Object){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(task)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createTaskController = CreateNewTask()
        createTaskController.rootController = self
        createTaskController.edit = true
        let task = taskList[indexPath.row]
        createTaskController.editedTask = task
        present(UINavigationController(rootViewController: createTaskController), animated: true, completion:{
            createTaskController.priorityField.text = String(task.priority)
            createTaskController.taskTextField.text = task.toDo
        })
    }
    
    
    func sortPressed(){
        let alertSheet = UIAlertController(title: "Sort", message: "Select how to sort", preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "By Priority", style: .default, handler: {(action)-> Void in
            self.taskList.sort(by: {$0.priority > $1.priority})
            self.tableView.reloadData()
        }))
        
        alertSheet.addAction(UIAlertAction(title: "By Date", style: .default, handler: {(action)-> Void in
            self.taskList.sort(by: {$0.date < $1.date})
            self.tableView.reloadData()
        }))
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action)-> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alertSheet, animated: true, completion: nil)
    }
    
    
    func addTask(task:Object){
        let realm = try! Realm()
        do{
            try realm.write {
                realm.add(task)
            }
        }catch{
            print("Something went wrong with addind data")
        }
        queryTasks()
    }
    
    
    
    /*
     loads all the tasks saved with realm
    */
    func queryTasks(){
        let realm = try! Realm()
        let result = realm.objects(TaskModel.self)
        taskList.removeAll()
        for task in result{
            taskList.append(task)
        }
        self.tableView.reloadData()
    }
    
   
    
    
    func addPressed(){
        let createTaskController = CreateNewTask()
        createTaskController.rootController = self
        present(UINavigationController(rootViewController: createTaskController), animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! TaskCell
        let curTask = taskList[indexPath.row]
        
        
        cell.taskLabel.text = curTask.toDo
        let date = Date(timeIntervalSince1970: curTask.date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd YYYY hh:mm a"
        let dateStr = formatter.string(from: date)
        cell.dateLabel.text = dateStr
        cell.priorityLabel.text = String(curTask.priority)
        

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
