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

    var tempTasksList: [String] = [String]()

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
        tableView.reloadData()
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
        return tempTasksList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as! TaskListCell
        cell.taskName.text = tempTasksList[indexPath.row]

        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tempTasksList[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteTask)

        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editTask)

        return [deleteAction, editAction]
    }

    // MARK: - Task Editting Handlers

    func editTask(action: UITableViewRowAction, indexPath: IndexPath) {
        // Edit stuff
        tableView.reloadData()
    }

    func deleteTask(action: UITableViewRowAction, indexPath: IndexPath) {
        tempTasksList.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }

    // MARK: - TextField Functions

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTask(textField)
        return true
    }

    func dismissKeyboard() {
        textField.resignFirstResponder()
    }

    @IBAction func addTask(_ sender: Any) {
        if let text = textField.text {
            if (text != "") {
                tempTasksList.insert(text, at: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                tableView.endUpdates()
                
                dismissKeyboard()
                textField.text = ""
            }
        }
    }
}
