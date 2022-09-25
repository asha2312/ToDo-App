//
//  TaskViewModel.swift
//  AshaSharma-ToDoApp
//
//  Created by Asha on 23/09/22.
//

//import Foundation
import CoreData
class TaskViewModel: ObservableObject {
    
    // MARK: Properties
    static let shared = TaskViewModel()
    let container: NSPersistentContainer
    var todo = [ToDo]()
    var seletedDateTodos: [ToDo] = []
    var selectedDate = Date()
    
    // MARK: init
    private init() {
        container = NSPersistentContainer(name: "AshaSharm_ToDoApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading todo: \(error)")
            }
        }
    }
    // MARK: - Core Data
    func saveContext() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func EditTask(task:String,description:String,date:Date,row:Int)
    {
        self.todo[row].setValue(task, forKey: "title")
        self.todo[row].setValue(description, forKey: "descriptions")
        self.todo[row].setValue(date, forKey: "date")
        self.saveContext()
    }
    
    func SaveTask(task:String,description:String,date:Date)
    {
        let context = container.viewContext
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
        newTask.setValue(UUID(), forKey: "id")
        newTask.setValue(task, forKey: "title")
        newTask.setValue(description, forKey: "descriptions")
        newTask.setValue(date, forKey: "date")
        do{
            try context.save()
            print("success")
        }catch{
            print("error")
        }
       
    }
    func getTask()->[ToDo]
    {
        let context = container.viewContext
        let todoFetch: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(ToDo.date), ascending: true)
        todoFetch.sortDescriptors = [sortByDate]
        do {
            let results = try context.fetch(todoFetch)
            todo = results
            return todo
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return []
    }
    func showDataAccordingToDate(_ date: Date)->[ToDo] {
        selectedDate = date
        var filteredList = todo.filter { todo in
            compareDate(selectedDate, todo.date ?? Date(),event: "todayTomorrow")
        }
        filteredList.sort{
            $0.date ?? Date() < $1.date ?? Date()
        }
        seletedDateTodos.removeAll()
        seletedDateTodos.append(contentsOf: filteredList)
        return filteredList
    }
    func showDataForUpcoming(_ date: Date)->[ToDo] {
        selectedDate = date
        var filteredList = todo.filter { todo in
            compareDate(selectedDate, todo.date ?? Date() ,event: "Upcoming")
        }
        filteredList.sort{
            $0.date ?? Date() < $1.date ?? Date()
        }
        seletedDateTodos.removeAll()
        seletedDateTodos.append(contentsOf: filteredList)
        return filteredList
    }
   
    
}
