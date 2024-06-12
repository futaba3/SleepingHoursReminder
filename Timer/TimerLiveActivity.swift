//
//  TimerLiveActivity.swift
//  Timer
//
//  Created by Ayana Kudo on 2024/06/12.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimerAttributes {
    fileprivate static var preview: TimerAttributes {
        TimerAttributes(name: "World")
    }
}

extension TimerAttributes.ContentState {
    fileprivate static var smiley: TimerAttributes.ContentState {
        TimerAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TimerAttributes.ContentState {
         TimerAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TimerAttributes.preview) {
   TimerLiveActivity()
} contentStates: {
    TimerAttributes.ContentState.smiley
    TimerAttributes.ContentState.starEyes
}
