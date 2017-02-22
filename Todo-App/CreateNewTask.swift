//
//  CreateNewTask.swift
//  Todo-App
//
//  Created by Admin on 2/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CreateNewTask: UIViewController {
    
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet weak var priorityField: UITextField!
    
    var rootController : TableViewController?
    
    let defaultPriority = 0
    var edit = false
    var editedTask :TaskModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create New Task"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        
        // Do any additional setup after loading the view.
    }
    /* safe check for memory cicles
    deinit {
        print("deiniting")
    }
     */
    
    func donePressed(){
        if let text = taskTextField.text, !text.isEmpty{
            let newTask = TaskModel()
            newTask.date = Date().timeIntervalSince1970
            newTask.toDo = text
            if priorityField.text != nil && Int(priorityField.text!) != nil{
                newTask.priority = Int(priorityField.text!)!
            }else{
                newTask.priority = 0
            }
            if(edit){//if we are editing a task instead of creating a new one then old task must be deleted
                rootController?.removeFromMemory(task: editedTask!)
            }
            
            rootController?.addTask(task: newTask)//upload a new task (or updated from the old one)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func backPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
