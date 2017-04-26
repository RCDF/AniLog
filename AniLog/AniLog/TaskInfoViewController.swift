//
//  TaskInfoViewController.swift
//  AniLog
//
//  Created by David Fang on 4/17/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit

class TaskInfoViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet var buttonCollection: [RadioButton]!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var task: Task?
    var tagNum: Int!
    var inEditMode: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (inEditMode == true) {
            initForEditMode()
        } else {
            initForNewTaskMode()
        }
        
        textField.delegate = self
        getCurrentButton()?.isSelected = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        textField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initForEditMode() {
        if let task = task {
            tagNum = Int(task.tagNum)
            textField.text = task.taskDescription
        } else {
            initForNewTaskMode()
        }
    }
    
    func initForNewTaskMode() {
        tagNum = 0
        textField.text = ""
    }
    
    
    // MARK: - Task Adding/Editting Services
    
    func commitTask() -> Bool {
        if let editMode = inEditMode {
            if let text = textField.text {
                if (text != "") {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if (!editMode) {
                        task = Task(context: context)
                        task?.taskDescription = text
                        task?.duration = 0
                        task?.tagNum = Int16(tagNum)
                        appDelegate.saveContext()
                    } else {
                        task?.taskDescription = text
                        task?.tagNum = Int16(tagNum)
                        appDelegate.saveContext()
                    }
                    return true
                }
            }  
        }

        return false
    }

    @IBAction func setTagNum(sender: RadioButton) {
        getCurrentButton()?.isSelected = false
        sender.isSelected = true
        tagNum = sender.tag
    }
    
    func getCurrentButton() -> RadioButton? {
        for button in buttonCollection {
            if button.tag == Int(tagNum) {
                return button
            }
        }
        return nil
    }

    // MARK: - Gesture Recognizer Delegates
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            if view is UIButton {
                return false
            }
        }
        
        return true
    }
    
    // MARK: - Textfield Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismissKeyboard()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func willCommitTask(sender: UIButton) {
        if (commitTask()) {
            performSegue(withIdentifier: "taskInfoToList", sender: sender)
        }
    }
}
