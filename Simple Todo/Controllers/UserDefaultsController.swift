//
//  UserDefaultsController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

class TaskDelegate: CodableUtil, ObservableObject {
    
    static let instance = TaskDelegate()
    
    @AppStorage("tasks") var rawTasks: String = ""
    @Published var taskModel: [TaskModel] = []
    
    override init() {
        super.init()
        self.loadTasks()
    }
    
    func uncompletedTask() -> [TaskModel] {
        taskModel.filter { task in
            task.status == .created
        }
    }
    
    func completedTask() -> [TaskModel] {
        taskModel.filter { task in
            task.status == .completed
        }
    }
    
    func totalTask() -> Int {
        taskModel.count
    }
    
    func totalCompletedTask() -> Int {
        taskModel.filter { task in
            task.status == .completed
        }.count
    }
    
    func overdueTasks() -> [TaskModel] {
        taskModel.filter({ $0.isOverdue() })
    }
    
    func totalOverdueTasks() -> Int {
        overdueTasks().count
    }
    
    func loadTasks() {
        self.taskModel = decode(taskModel, from: rawTasks) ?? taskModel
    }
    
    func getTask(by id: String) -> TaskModel? {
        return taskModel.first { task in
            task.id == id
        }
    }
    
    func saveTask(_ data: TaskModel) {
        if let index = taskModel.firstIndex(where: { task in
            task.id == data.id
        }) {
            taskModel[index] = data
        } else {
            taskModel.append(data)
        }
        
       save()
    }
    
    func clearTask() {
        taskModel = []
        
        save()
    }
    
    func deleteAllDone() {
        taskModel.removeAll { task in
            task.status == .completed
        }
        save()
    }
    
    func delete(task: TaskModel) {
        guard let index = taskModel.firstIndex(where: { t in
            t.id == task.id
        }) else {
            return
        }
        
        taskModel.remove(at: index)
        save()
    }
    
    private func save() {
        guard let taskJson = encode(data: taskModel) else {
            return
        }
        
        rawTasks = taskJson
    }
}
