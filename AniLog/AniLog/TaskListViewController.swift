//
//  TaskListViewController.swift
//  AniLog
//
//  Created by David Fang on 3/20/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasksList: [Task] = []
    var selectedRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.icebergBlue.cgColor

        textField.delegate = self
        textField.inputAccessoryView = initializeKeyboard()

        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapDismiss.delegate = self
        view.addGestureRecognizer(tapDismiss)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTasksFromCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            if view is UITableViewCell || view.superview is UITableViewCell || view.superview?.superview is UITableViewCell {
                return false
            }
        }

        return true
    }

    func initializeKeyboard() -> UIToolbar {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissKeyboard))

        keyboardToolbar.barStyle = .default
        keyboardToolbar.items = [closeButton]
        keyboardToolbar.sizeToFit()

        return keyboardToolbar
    }


    // MARK: - TableView Delegate Functions

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as! TaskListCell
        cell.taskName.text = tasksList[indexPath.row].task_description

        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueToTimer", sender: self)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteTaskAction)

        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editTaskAction)

        return [deleteAction, editAction]
    }

    
    // MARK: - Task Editting Handlers
    
    func editTask(row: Int) {
        tableView.reloadData()
    }
    
    func deleteTask(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let task = tasksList[indexPath.row]
        
        tasksList.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        // Remove from Core Data
        context.delete(task)
        appDelegate.saveContext()
    }
    
    func addTask() {
        if let text = textField.text {
            if (text != "") {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let task = Task(context: context)
                task.duration = 30      // default minutes
                task.task_description = text
                task.completed = false
                task.tag_num = 0
                appDelegate.saveContext()
                
                tasksList.insert(task, at: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                tableView.endUpdates()
                
                dismissKeyboard()
                textField.text = ""
            }
        }
    }
    
    func fetchTasksFromCoreData() {
        do {
            tasksList = try context.fetch(Task.fetchRequest()).reversed()
        } catch {
            print("ERROR: Could not fetch tasks from CoreData")
        }
    }
    
    func editTaskAction(action: UITableViewRowAction, indexPath: IndexPath) {
        editTask(row: indexPath.row)
    }
    
    func deleteTaskAction(action: UITableViewRowAction, indexPath: IndexPath) {
        deleteTask(row: indexPath.row)
    }


    // MARK: - TextField Functions

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTask()
        return true
    }

    func dismissKeyboard() {
        textField.resignFirstResponder()
    }

    @IBAction func willAddTask(_ sender: Any) {
        addTask()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTimer" {
            if let dest = segue.destination as? TimerViewController {
                if let cellRow = selectedRow {
                    let task = tasksList[cellRow]
                    dest.timerDuration = task.duration
                }
            }
        }
    }
    
    @IBAction func unwindToTaskList(segue: UIStoryboardSegue) {
        if (segue.identifier == "timerToTaskList") {
            if let src = segue.source as? TimerViewController {
                if src.aniTimer.isComplete() {
                    deleteTask(row: selectedRow!)
                }
            }
        }
    }
    
}
