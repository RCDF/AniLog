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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var task: Task?
    var tagNum: Int16 = 0   // default
    var inEditMode: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        textField.inputAccessoryView = initializeKeyboard()
        
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapDismiss.delegate = self
        view.addGestureRecognizer(tapDismiss)
        
        textField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initForEditMode() {
        
    }
    
    func initForNewTaskMode() {
        
    }
    
    func initializeKeyboard() -> UIToolbar {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissKeyboard))
        
        keyboardToolbar.barStyle = .default
        keyboardToolbar.items = [closeButton]
        keyboardToolbar.sizeToFit()
        
        return keyboardToolbar
    }
    
    func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
    
    // MARK: - Task Adding/Editting Services
    
    func commitTask() {
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
                        
                        // performSegue
                    } else {
                        // Alert that there must be a field
                    }
                }
                
            }
        }
    }

    @IBAction func setTagNum(sender: UIButton) {
        tagNum = Int16(sender.tag)
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
        
        // Add what you want the Done button to do
        
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
        commitTask()
        performSegue(withIdentifier: "taskInfoToList", sender: sender)
    } 
    

}
