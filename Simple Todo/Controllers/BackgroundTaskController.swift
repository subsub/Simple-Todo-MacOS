//
//  BackgroundTaskController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI
import BackgroundTasks

let bgTaskIdentifier = "id.subkhansarif.Simple-Todo"
class BackgroundTaskController {
    static let instance = BackgroundTaskController(taskDelegate: UserDefaultsDelegates.instance)
    
    let scheduler = NSBackgroundActivityScheduler(identifier: bgTaskIdentifier)
    let taskDelegate: UserDefaultsDelegates
    
    init(taskDelegate: UserDefaultsDelegates) {
        self.taskDelegate = taskDelegate
    }
    
    func schedule(at date: Date, for id: String, _ mainCompletion: @escaping ()->Void) {
        scheduler.schedule { [weak self] completion in
            print(">> background task running...")
            DispatchQueue.main.async {
                self?.taskDelegate.loadTasks()
                mainCompletion()
            }
            completion(NSBackgroundActivityScheduler.Result.finished)
            print(">> background task complete")
        }
        print(">> scheduled background task for id: \(id)")
    }
}
