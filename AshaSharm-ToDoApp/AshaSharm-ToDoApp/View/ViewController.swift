//
//  ViewController.swift
//  AshaSharma-ToDoApp
//
//  Created by Asha on 23/09/22.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var btnUpcoming: UIButton!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var btnTomorrow: UIButton!
    @IBOutlet weak var tblTodokList: UITableView!
    
    @IBOutlet weak var btnUpcomingAddTask: UIButton!
    @IBOutlet weak var btnTomorrowAddTask: UIButton!
    @IBOutlet weak var btnTodayAddTask: UIButton!
    
    @IBOutlet weak var imgUpcomingArrow: UIImageView!
    @IBOutlet weak var imgTomorrowArrow: UIImageView!
    @IBOutlet weak var imgTodayArrow: UIImageView!
    
    let cellReuseIdentifier = "taskTVC"
    var dictTask : [Int : String] = [:]
    var tasks: [ToDo] = []
    let getEventDate = getDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tasks = TaskViewModel.shared.getTask()
        setUI()
    }
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("newData"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    func setUI()
    {
        navigationItem.title = "Home"
        self.tblTodokList.delegate = self
        self.tblTodokList.dataSource = self
        self.tblTodokList.register(UINib(nibName: "taskTVC", bundle: nil),
                                forCellReuseIdentifier: cellReuseIdentifier)
        ButtonUI(button: btnToday)
        ButtonUI(button: btnTomorrow)
        ButtonUI(button: btnUpcoming)
        
        roundButton(button: btnTodayAddTask)
        roundButton(button: btnTomorrowAddTask)
        roundButton(button: btnUpcomingAddTask)
        
        roundImage(img: imgTodayArrow)
        roundImage(img: imgTomorrowArrow)
        roundImage(img: imgUpcomingArrow)
        
    }
    @objc func getData(){
        tasks = TaskViewModel.shared.getTask()
        tblTodokList.reloadData()
    }
   
    // MARK: - button click event
    @IBAction func btnDateWise_Click(_ sender: Any) {
        var tempDate : Date!
        var header : String!
        if (sender as AnyObject).tag == 1{
            tempDate = getEventDate.0
            header = "Today"
        }else if (sender as AnyObject).tag == 2{
            tempDate = getEventDate.1
            header = "Tomorrow"
        }else {
            tempDate = getEventDate.2
            header = "Upcoming"
        }
        let TodoDatewiseVC = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TodoDatewise") as? TodoDatewise)!
        TodoDatewiseVC.condDate = tempDate
        TodoDatewiseVC.ViewHeader = header
        self.navigationController?.pushViewController(TodoDatewiseVC, animated: true)
    }
    
    @IBAction func btnAddTask_Click(_ sender: Any) {
       
        let taskVC = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTaskVC") as? AddTaskVC)!
        if (sender as AnyObject).tag == 1{
            taskVC.date = getEventDate.0
        }else if (sender as AnyObject).tag == 2{
            taskVC.date = getEventDate.1
        }else {
            taskVC.date = nil
        }
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tasks.count
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // Swipe to delete a note
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            let context = TaskViewModel.shared.container.viewContext
            context.delete(self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            TaskViewModel.shared.saveContext()
            self.tblTodokList.deleteRows(at: [indexPath], with: .automatic)
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


