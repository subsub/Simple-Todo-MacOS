//
//  UserDefaultsController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

private let jsonEncoder = JSONEncoder()
private let jsonDecoder = JSONDecoder()

class UserDefaultsDelegates: ObservableObject {
    
    static let instance = UserDefaultsDelegates()
    
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
    
    @AppStorage("tasks") var rawTasks: String = ""
    @Published var taskModel: [TaskModel] = []
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        self.taskModel = decodeTasks()
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
        guard let taskJson = encodeTasks() else {
            return
        }
        
        rawTasks = taskJson
    }
    
    private func encodeTasks() -> String? {
        do {
            let jsonData = try jsonEncoder.encode(taskModel)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            print(">> encodeTasks: \(String(describing: json))")
            return json
        } catch {
            print(">> Failed encode tasks")
        }
        return nil
    }
    
    private func decodeTasks() -> [TaskModel] {
        do {
            guard let jsonData = rawTasks.data(using: String.Encoding.utf8) else {
                return []
            }
            let task = try jsonDecoder.decode([TaskModel].self, from: jsonData)
            print(">> decodeTasks: \(task)")
            return task
        } catch {
            print(">> Failed to decode Tasks")
        }
        return []
    }
    
}
