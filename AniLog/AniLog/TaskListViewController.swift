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
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.textField.delegate = self
        
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapDismiss.delegate = self
        view.addGestureRecognizer(tapDismiss)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // A gesture recognizer for tap dismissal to make sure
    // UITableViewCell selection is not blocked
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if let view = touch.view {
            if view is UITableViewCell || view.superview is UITableViewCell || view.superview?.superview is UITableViewCell {
                return false
            }
        }

        return true
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
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                tableView.endUpdates()
                
                dismissKeyboard()
                textField.text = ""
            }
        }
    }
}
