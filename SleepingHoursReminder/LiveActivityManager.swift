//
//  LiveActivityManager.swift
//  SleepingHoursReminder
//
//  Created by Ayana Kudo on 2024/06/12.
//

//import Foundation
//import ActivityKit
//
//class LiveActivityManager {
//    static let shared = LiveActivityManager()
//    
//    private var activity: Activity<TimerAttributes>?
//    
//    private init() {}
//    
//    func startActivity(timeRemaining: String) {
//        let attributes = TimerAttributes(name: "Timer")
//        let contentState = TimerAttributes.ContentState(timeRemaining: timeRemaining)
//        do {
//            activity = try Activity<TimerAttributes>.request(attributes: attributes, contentState: contentState)
//        } catch {
//            print("Failed to start activity: \(error)")
//        }
//    }
//    
//    func updateActivity(timeRemaining: String) {
//        Task {
//            let contentState = TimerAttributes.ContentState(timeRemaining: timeRemaining)
//            if let activity = activity {
//                await activity.update(using: contentState)
//            }
//        }
//    }
//    
//    func endActivity() {
//        Task {
//            if let activity = activity {
//                await activity.end(dismissalPolicy: .immediate)
//                self.activity = nil
//            }
//        }
//    }
//}

import Foundation
import ActivityKit

class LiveActivityManager {
    func updateActivity(activityID: String, timeRemaining: String) {
        Task {
            let contentState = TimerAttributes.ContentState(
                timeRemaining: timeRemaining
            )
            if let activity = Activity<TimerAttributes>.activities.first(where: { $0.id == activityID }) {
                await activity.update(using: contentState)
            }
        }
    }
    
    func endActivity() {
        Task {
            for activity in Activity<TimerAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }

    func updateAllActivities() {
        Task {
            for activity in Activity<TimerAttributes>.activities {
                let newTimeRemaining = calculateNewTimeRemaining(for: activity)
                let contentState = TimerAttributes.ContentState(timeRemaining: newTimeRemaining)
                await activity.update(using: contentState)
            }
        }
    }

    private func calculateNewTimeRemaining(for activity: Activity<TimerAttributes>) -> String {
        // ここで新しい残り時間を計算
        // 現在の時間と終了時間を比較して残り時間を計算
        // 例: "00:10"のようにフォーマットされた時間を返す
        return "00:10"
    }
}
