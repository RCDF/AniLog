//
//  TaskListViewController.swift
//  AniLog
//
//  Created by David Fang on 3/20/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var tempTasksList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.textField.delegate = self
        self.textField.clearButtonMode = UITextFieldViewMode.whileEditing
        
        let tapDismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TaskListViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapDismiss)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    }
    
    // MARK: - TextField Functions
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        if let text = textField.text {
            dismissKeyboard()
            tempTasksList.append(text)
            textField.text = ""

            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: tempTasksList.count-1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}
