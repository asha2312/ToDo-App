//
//  TodoDatewise.swift
//  AshaSharm-ToDoApp
//
//  Created by Asha on 24/09/22.
//

import UIKit

class TodoDatewise: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblTodoList: UITableView!
    let cellReuseIdentifier = "taskTVC"
    var condDate : Date!
    var ViewHeader : String!
    var tasks: [ToDo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ViewHeader
        setUI()
    }
    func setUI()
    {
        self.tblTodoList.delegate = self
        self.tblTodoList.dataSource = self
        self.tblTodoList.register(UINib(nibName: "taskTVC", bundle: nil),
                                  forCellReuseIdentifier: cellReuseIdentifier)
        if ViewHeader == "Upcoming" {
            tasks = TaskViewModel.shared.showDataForUpcoming(condDate)
        }else {
            tasks = TaskViewModel.shared.showDataAccordingToDate(condDate)
        }
        self.tblTodoList.reloadData()
    }
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("newData"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    @objc func getData(){
        if ViewHeader == "Upcoming" {
            tasks = TaskViewModel.shared.showDataForUpcoming(condDate)
        }else {
            tasks = TaskViewModel.shared.showDataAccordingToDate(condDate)
        }
        tblTodoList.reloadData()
    }
    // MARK: - Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tasks.count == 0{
            tblTodoList.setNoDataPlaceholder("No Records Found.")
        }
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: taskTVC = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! taskTVC
        let rowTodo = self.tasks[indexPath.row]
        cell.lblTodoName.text = rowTodo.title
        cell.lblTodoDescription.text = rowTodo.descriptions
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let taskVC = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTaskVC") as? AddTaskVC)!
        let rowTodo = self.tasks[indexPath.row]
        taskVC.task = rowTodo
        taskVC.index = indexPath.row
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            let context = TaskViewModel.shared.container.viewContext
            context.delete(self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            TaskViewModel.shared.saveContext()
            self.tblTodoList.deleteRows(at: [indexPath], with: .automatic)
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            complete(true)
        }
        deleteAction.image = UIImage(systemName: "xmark.circle")
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
      
    }


}
