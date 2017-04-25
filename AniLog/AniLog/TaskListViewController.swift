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

    @IBOutlet weak var tableView: FadingTableView!
    @IBOutlet weak var numTasksLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var newTaskButton: PlusButtonView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasksList: [Task] = []
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        updateDateLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        updateDateLabels()
        fetchTasksFromCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func updateDateLabels() {
        let date = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()

        dayLabel.text = String(calendar.component(.day, from: date))
        monthLabel.text = dateFormatter.shortMonthSymbols[calendar.component(.month, from: date) - 1].uppercased()
        yearLabel.text = String(calendar.component(.year, from: date))
        weekdayLabel.text = dateFormatter.weekdaySymbols[calendar.component(.weekday, from: date) - 1]
    }
    
    func updateNumTasks() {
        numTasksLabel.text = String(tasksList.count)
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
        let task = tasksList[indexPath.row]
        cell.taskName.text = task.taskDescription
        cell.taskTag.backgroundColor = getTagColor(task.tagNum)
        cell.taskColor = getTagColor(task.tagNum)

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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.updateGradients()
    }
    
    // MARK: - Task Editting Handlers
    
    func editTask(row: Int) {
        selectedRow = row
        performSegue(withIdentifier: "segueToTaskInfo", sender: self)
        // tableView.reloadData()
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
        updateNumTasks()
    }
    
    func addTask(task: Task, row: Int) {
        tasksList.insert(task, at: row)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .none)
        tableView.endUpdates()
        updateNumTasks()
    }
    
    func fetchTasksFromCoreData() {
        do {
            tasksList = try context.fetch(Task.fetchRequest()).reversed()
            updateNumTasks()
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
                if sender is PlusButtonView {
                    dest.inEditMode = false
                } else {
                    dest.inEditMode = true
                    if let cellRow = selectedRow {
                        let task = tasksList[cellRow]
                        dest.task = task
                    }
                }
                
            }
        } else if segue.identifier == "segueToTimer" {
            if let dest = segue.destination as? TimerViewController {
                if let cellRow = selectedRow {
                    let task = tasksList[cellRow]
                    dest.task = task
                }
            }
        }
    }
    
    @IBAction func unwindToTaskList(segue: UIStoryboardSegue) {
        if (segue.identifier == "timerToTaskList") {
            if let src = segue.source as? TimerViewController {
                if src.aniTimer.isComplete() {
                    // deleteTask(row: selectedRow!)
                    // handle deletion here
                    // add task to completed task
                }
            }
        } else if (segue.identifier == "taskInfoToList") {
            if let src = segue.source as? TaskInfoViewController {
                if let editMode = src.inEditMode {
                    if (!editMode) {
                        addTask(task: src.task!, row: 0)
                    } else {
                        fetchTasksFromCoreData()
                        tableView.reloadData()
                    }
                }
            }
        }
    }
}
