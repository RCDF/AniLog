//
//  TaskListViewController.swift
//  AniLog
//
//  Created by David Fang on 3/20/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit
import QuartzCore

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasksList: [Task] = []
    var selectedRow: Int?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTasksFromCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        context.delete(task)
        appDelegate.saveContext()
    }
    
    func addTask(task: Task) {
        tasksList.insert(task, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableView.endUpdates()
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

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTaskInfo" {
            if let dest = segue.destination as? TaskInfoViewController {
                dest.inEditMode = false
            }
        } else if segue.identifier == "segueToTimer" {
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
        } else if (segue.identifier == "taskInfoToList") {
            if let src = segue.source as? TaskInfoViewController {
                if let editMode = src.inEditMode {
                    if (!editMode) {
                        addTask(task: src.task!)
                    } else {
                        
                    }
                }
            }
        }
    }
    
}
