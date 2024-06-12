//
//  ContentView.swift
//  SleepingHoursReminder
//
//  Created by Ayana Kudo on 2024/06/12.
//

//import SwiftUI
//import ActivityKit

//struct ContentView: View {
//    @State private var selectedDate = Date()
//    @State private var isTimerActive = false
//    @State private var timeRemaining: String = ""
//    @State private var timer: Timer?
//    
//    var body: some View {
//        VStack {
//            DatePicker("Set Time", selection: $selectedDate, displayedComponents: .hourAndMinute)
//                .datePickerStyle(WheelDatePickerStyle())
//                .labelsHidden()
//                .padding()
//            
//            HStack {
//                Button(action: startTimer) {
//                    Text("Start Timer")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                Button(action: stopTimer) {
//                    Text("Stop Timer")
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//            }
//            
//            if isTimerActive {
//                Text("Time Remaining: \(timeRemaining)")
//                    .padding()
//            }
//        }
//        .padding()
//        .onAppear {
//            startBackgroundUpdates()
//        }
//    }
//    
//    private func startTimer() {
//        isTimerActive = true
//        updateTimeRemaining()
//        
//        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
//            updateTimeRemaining()
//        }
//        
//        // Start the live activity
//        LiveActivityManager.shared.startActivity(timeRemaining: timeRemaining)
//    }
//    
//    private func stopTimer() {
//        isTimerActive = false
//        timer?.invalidate()
//        timer = nil
//        
//        // Stop the live activity
//        LiveActivityManager.shared.endActivity()
//    }
//    
//    private func updateTimeRemaining() {
//        let now = Date()
//        let calendar = Calendar.current
//        let selectedDateToday = calendar.date(bySettingHour: calendar.component(.hour, from: selectedDate),
//                                              minute: calendar.component(.minute, from: selectedDate),
//                                              second: 0,
//                                              of: now) ?? selectedDate
//        
//        let components = calendar.dateComponents([.hour, .minute], from: now, to: selectedDateToday)
//        
//        if let hours = components.hour, let minutes = components.minute {
//            let totalMinutes = (hours * 60) + minutes
//            if totalMinutes >= 0 {
//                timeRemaining = String(format: "%02d:%02d", hours, minutes)
//            } else {
//                let adjustedTime = (24 * 60) + totalMinutes
//                timeRemaining = String(format: "%02d:%02d", adjustedTime / 60, adjustedTime % 60)
//            }
//        }
//        
//        // Update the live activity with the new time remaining
//        LiveActivityManager.shared.updateActivity(timeRemaining: timeRemaining)
//    }
//    
//    private func startBackgroundUpdates() {
//        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
//            updateTimeRemaining()
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}

import SwiftUI
import ActivityKit
import BackgroundTasks

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var isTimerActive = false
    @State private var timeRemaining: String = ""
    @State private var timer: Timer?
    @State private var activityID: String?
    
    var body: some View {
        VStack {
            DatePicker("Set Time", selection: $selectedDate, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
            
            HStack {
                Button(action: startTimer) {
                    Text("Start Timer")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Button(action: stopTimer) {
                    Text("Stop Timer")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            if isTimerActive {
                Text("Time Remaining: \(timeRemaining)")
                    .padding()
            }
        }
        .padding()
        .onAppear {
            scheduleBackgroundTask()
        }
    }
    
    private func startTimer() {
        isTimerActive = true
        updateTimeRemaining()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            updateTimeRemaining()
        }
        
        // Start the live activity here
        let attributes = TimerAttributes(name: "Timer")
        let contentState = TimerAttributes.ContentState(timeRemaining: timeRemaining)
        do {
            let activity = try Activity<TimerAttributes>.request(attributes: attributes, contentState: contentState)
            activityID = activity.id
        } catch {
            print("Failed to start activity: \(error)")
        }
    }
    
    private func stopTimer() {
        isTimerActive = false
        timer?.invalidate()
        timer = nil
        
        // Stop the live activity
        LiveActivityManager().endActivity()
    }
    
    private func updateTimeRemaining() {
        let now = Date()
        let calendar = Calendar.current
        let selectedDateToday = calendar.date(bySettingHour: calendar.component(.hour, from: selectedDate),
                                              minute: calendar.component(.minute, from: selectedDate),
                                              second: 0,
                                              of: now) ?? selectedDate
        
        let components = calendar.dateComponents([.hour, .minute], from: now, to: selectedDateToday)
        
        if let hours = components.hour, let minutes = components.minute {
            let totalMinutes = (hours * 60) + minutes
            if totalMinutes >= 0 {
                timeRemaining = String(format: "%02d:%02d", hours, minutes)
            } else {
                let adjustedTime = (24 * 60) + totalMinutes
                timeRemaining = String(format: "%02d:%02d", adjustedTime / 60, adjustedTime % 60)
            }
        }
        
        // Update the live activity with the new time remaining
        if let activityID = activityID {
            LiveActivityManager().updateActivity(activityID: activityID, timeRemaining: timeRemaining)
        }
    }

    private func scheduleBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "com.kudoayana.SleepingHoursReminder.timer")
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
