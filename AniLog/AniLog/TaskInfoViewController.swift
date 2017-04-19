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
    @IBOutlet var buttonCollection: [RoundButton]!    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var task: Task?
    var tagNum: Int16 = 0   // default
    var inEditMode: Bool?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapDismiss.delegate = self
        view.addGestureRecognizer(tapDismiss)
        
        getCurrentButton()?.isSelected = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initForEditMode() {
        
    }
    
    func initForNewTaskMode() {
        
    }
    
    func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
    
    // MARK: - Task Adding/Editting Services
    
    func commitTask() -> Bool {
        if let editMode = inEditMode {
            if (!editMode) {
                if let text = textField.text {
                    if (text != "") {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        task = Task(context: context)
                        task?.task_description = text
                        task?.completed = false
                        task?.duration = 0
                        task?.tagNum = tagNum
                        appDelegate.saveContext()
                        
                        return true
                    } else {
                        // Have alert that task cannot be empty
                    }
                }
                
            }
        }

        return false
    }

    @IBAction func setTagNum(sender: RoundButton) {
        getCurrentButton()?.isSelected = false
        sender.isSelected = true
        tagNum = Int16(sender.tag)
    }
    
    func getCurrentButton() -> RoundButton? {
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
        dismissKeyboard()
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
