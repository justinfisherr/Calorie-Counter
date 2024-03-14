//
//  Calorie_Counter_Widget.swift
//  Calorie-Counter-Widget
//
//  Created by Justin Fisher on 3/12/24.
//

import WidgetKit
import SwiftUI

//Supplies data!
struct Provider: TimelineProvider {
    func getTDEE() -> Double {
         // Assuming "tdee" is saved as an integer in UserDefaults
        let tdee = UserDefaults(suiteName:"group.com.calories.counter")?.double(forKey: "tdee") ?? 0.0
        return tdee
     }
    
    func getCaloriesConsumed() -> Double {
         // Assuming "tdee" is saved as an integer in UserDefaults
        let caloriesConsumed = UserDefaults(suiteName:"group.com.calories.counter")?.double(forKey: "caloriesConsumed") ?? 0.0
        return caloriesConsumed
     }

     func placeholder(in context: Context) -> SimpleEntry {
         // You can use the retrieved "tdee" value here or use a default value
         let tdee = getTDEE()
         return SimpleEntry(date: Date(), emoji: "😀", tdee: tdee,caloriesConsumed: getCaloriesConsumed())
     }

     func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
         let tdee = getTDEE()
         let entry = SimpleEntry(date: Date(), emoji: "😀", tdee: tdee,caloriesConsumed: getCaloriesConsumed())
         completion(entry)
     }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀", tdee: getTDEE(), caloriesConsumed: getCaloriesConsumed())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
         
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let tdee: Double
    let caloriesConsumed: Double
}

struct Calorie_Counter_WidgetEntryView : View {
    var entry: Provider.Entry
    //@Environment(\.widgetFamily) var widgetFamily
    //The view
    var body: some View {
        ProgressBar(caloriesConsumed: entry.caloriesConsumed, tdee: entry.tdee)
            .containerBackground(.black, for:.widget)
        
        /*
        switch widgetFamily{
        case .accessoryCircular:
            VStack {
                Text("Circular")
                
                Text("TDEE")
                Text(String(entry.tdee))
            }
        case .accessoryInline:
            VStack {
                Text("Inline")
                
                Text("TDEE")
                Text(String(entry.tdee))
            }
        case .accessoryRectangular:
            VStack {
                Text("Rect")
                
                Text("TDEE")
                Text(String(entry.tdee))
            }
        default: Text("Not implemented")
        }*/
    }
}

//Actual Widget
struct Calorie_Counter_Widget: Widget {
    let kind: String = "Calorie_Counter_Widget"

    //Like a view
    var body: some WidgetConfiguration {
        //Types of widget you can have
        //Provider is supplier of data
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                Calorie_Counter_WidgetEntryView(entry: entry)
                    .containerBackground(.black, for: .widget)
            } else {
                Calorie_Counter_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}
struct ProgressBar: View {
    var caloriesConsumed: Double
    var tdee: Double

    var body: some View {
            ZStack {
                Circle().stroke(Color.white.opacity(0.1), lineWidth: 20)

                let percentage = caloriesConsumed / tdee

                Circle()
                    .trim(from: 0, to: CGFloat(percentage))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))

                VStack {
                    Text("\(Int(caloriesConsumed))")
                        .foregroundStyle(.white)
                }
                
            }
            
        Button(intent: CalorieIntent()){Text("+100")}
    }
}

#Preview(as: .systemSmall) {
    Calorie_Counter_Widget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀", tdee: 1000, caloriesConsumed: 2000)
    SimpleEntry(date: .now, emoji: "🤩", tdee: 1000, caloriesConsumed: 2000)
}
