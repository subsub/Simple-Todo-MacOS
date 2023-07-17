//
//  UserDefaultsController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

class TaskDelegate: ObservableObject {
    
    static let instance = TaskDelegate()
    
    @AppStorage("tasks") var rawTasks: String = ""
    @AppStorage("myself") var rawMyself: String = ""
    @Published var myself: MySelf? = nil
    @Published var taskModel: [TaskModel] = []
    
    init() {
        self.loadTasks()
    }
    
    func hasTask(jiraId: String) -> (Bool, TaskModel?) {
        let taskWithJira = taskModel.first(where: { task in
            return task.jiraCard == jiraId
        })
        return (taskWithJira != nil, taskWithJira)
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
        taskModel.filter({ $0.isOverdue() && $0.status != .completed })
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
    
    func saveMyself(_ myself: MySelf) {
        self.myself = myself
        save()
    }
    
    func loadMyself() {
        self.myself = decode(self.myself, from: rawMyself) ?? self.myself
    }
    
    private func save() {
        guard let taskJson = encode(data: taskModel) else {
            return
        }
        
        guard let myselfJson = encode(data: myself) else {
            return
        }
        
        rawTasks = taskJson
        rawMyself = myselfJson
    }
}
