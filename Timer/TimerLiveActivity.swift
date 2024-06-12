//
//  TimerLiveActivity.swift
//  Timer
//
//  Created by Ayana Kudo on 2024/06/12.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            // ロック画面
            VStack {
                HStack {
                    Image(systemName: "timer")
                    Spacer()
                    Text(context.state.timeRemaining)
                }
                .padding()
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "timer")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.timeRemaining)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                }
            } compactLeading: {
                Image(systemName: "timer")
            } compactTrailing: {
                Text(context.state.timeRemaining)
            } minimal: {
                Text(context.state.timeRemaining)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimerAttributes {
    fileprivate static var preview: TimerAttributes {
        TimerAttributes(name: "Timer")
    }
}

extension TimerAttributes.ContentState {
    fileprivate static var initialState: TimerAttributes.ContentState {
        TimerAttributes.ContentState(timeRemaining: "00:00")
    }
    
    fileprivate static var starEyes: TimerAttributes.ContentState {
        TimerAttributes.ContentState(timeRemaining: "00:00")
    }
}

//#Preview("Notification", as: .content, using: TimerAttributes.preview) {
//    TimerLiveActivity()
//} contentStates: {
//    TimerAttributes.ContentState.initialState
//    TimerAttributes.ContentState.starEyes
//}
