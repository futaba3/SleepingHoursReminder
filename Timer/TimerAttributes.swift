//
//  TimerAttributes.swift
//  SleepingHoursReminder
//
//  Created by Ayana Kudo on 2024/06/12.
//

import ActivityKit

struct TimerAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var timeRemaining: String
    }

    var name: String
}
