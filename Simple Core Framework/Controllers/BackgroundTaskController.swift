//
//  BackgroundTaskController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI
import BackgroundTasks

let bgTaskIdentifier = "id.subkhansarif.Simple-Todo"
class BackgroundTaskController: ObservableObject {
    static let instance = BackgroundTaskController(taskDelegate: TaskDelegate.instance)
    
    let scheduler = NSBackgroundActivityScheduler(identifier: bgTaskIdentifier)
    let taskDelegate: TaskDelegate
    
    @Published var reloadCount: Double = 0
    
    init(taskDelegate: TaskDelegate) {
        self.taskDelegate = taskDelegate
        
        // scheduling an activity to fire every 5 minutes
        self.scheduler.interval = 5 * 60
        self.scheduler.tolerance = 3 * 50
        self.scheduler.repeats = true
    }
    
    func scheduleRefresh() {
        scheduler.schedule { [weak self] completion in
            print(">> background task running...")
            DispatchQueue.main.async {
                self?.taskDelegate.loadTasks()
                self?.reloadCount += 1
            }
            completion(NSBackgroundActivityScheduler.Result.finished)
            print(">> background task complete")
        }
    }
}
