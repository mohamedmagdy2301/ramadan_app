//
//  TimePrayer.swift
//  TimePrayer
//
//  Created by MohamedMego on 18/03/2025.
//
import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nextPrayer: "Loading...", remainingTime: "--:--")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), nextPrayer: "Fajr", remainingTime: "1h 20m")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.timePrayer")
        let nextPrayer = userDefaults?.string(forKey: "nextPrayer") ?? "Unknown"
        let remainingTime = userDefaults?.string(forKey: "remainingTime") ?? "--:--"
        
        let entry = SimpleEntry(date: Date(), nextPrayer: nextPrayer, remainingTime: remainingTime)
        
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
        completion(timeline)
    }
}

struct SimpleEntry:TimelineEntry {
    let date: Date
    let nextPrayer: String
    let remainingTime: String
}


struct NextPrayerWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("الصلاة القادمة") // "Next Prayer" in Arabic
                .font(.subheadline)
                .foregroundColor(.white)

            Text(entry.nextPrayer) // Prayer name in Arabic
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing) // Ensure proper RTL alignment

            Text(entry.remainingTime)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .containerBackground(Color.brown, for: .widget) // Background color
    }
}

@main
struct TimePrayer: Widget {
    let kind: String = "NextPrayerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NextPrayerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Next Prayer Widget")
        .description("Shows the upcoming prayer time.")
        .supportedFamilies([.systemSmall])
    }
}
