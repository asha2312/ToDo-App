//
//  AddTaskVC.swift
//  AshaSharma-ToDoApp
//
//  Created by Asha on 23/09/22.
//

import UIKit

class AddTaskVC: UIViewController {

    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtTaskName: UITextField!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var descriptionTopConst: NSLayoutConstraint!
    var task:ToDo!
    var index : Int!
    var date : Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        if task != nil{
            self.txtTaskName.text = task.title
            self.txtDescription.text = task.descriptions
            navigationItem.title = "Edit Task"
        }else {
            navigationItem.title = "Add Task"
        }
        if date != nil{
            dateStackView.isHidden = true
            descriptionTopConst.constant = -74
        }else {
            if task != nil{
                self.datePicker.date = task.date ?? Date()
            }
            descriptionTopConst.constant = 0
            dateStackView.isHidden = false
        }

    }


    @IBAction func btnSave_Click(_ sender: Any) {
        var SendDateToDB : Date!
        if date != nil{
            SendDateToDB = date
        }else {
            SendDateToDB = datePicker.date
        }
        let cval = checkValidation()
        if cval.0{
            if task != nil{
                TaskViewModel.shared.EditTask(task: txtTaskName.text ?? "", description: txtDescription.text ?? "", date: SendDateToDB, row: index)
            }else {
                TaskViewModel.shared.SaveTask(task: txtTaskName.text ?? "", description: txtDescription.text ?? "", date: SendDateToDB)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            self.navigationController?.popViewController(animated: true)
            
        }else {
            showAlert(withTitle: "Oops", message: cval.1, viewcontroller: self)
        }
       
    }
    
    func checkValidation() -> (Bool,String) {
        if checkTextValue(txtTaskName) {
            return (false,"Please Enter Task")
        }
        return (true,"")
    }
}
