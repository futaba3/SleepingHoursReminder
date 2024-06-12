//
//  SleepingHoursReminderApp.swift
//  SleepingHoursReminder
//
//  Created by Ayana Kudo on 2024/06/12.
//

import SwiftUI
import BackgroundTasks

@main
struct SleepingHoursReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.kudoayana.SleepingHoursReminder.timer", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
        return true
    }
    
    func handleBackgroundTask(task: BGProcessingTask) {
        scheduleBackgroundTask() // 次のタスクをスケジュール
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        // バックグラウンドでの作業をここで実行
        updateTimer()
        
        task.setTaskCompleted(success: true)
    }
    
    func scheduleBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "com.kudoayana.SleepingHoursReminder.timer")
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }
    
    func updateTimer() {
        // ここでタイマーの更新を行う
        LiveActivityManager().updateAllActivities()
    }
}
