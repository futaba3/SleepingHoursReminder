//
//  TimerBundle.swift
//  Timer
//
//  Created by Ayana Kudo on 2024/06/12.
//

import WidgetKit
import SwiftUI

@main
struct TimerBundle: WidgetBundle {
    var body: some Widget {
        Timer()
        TimerLiveActivity()
    }
}
