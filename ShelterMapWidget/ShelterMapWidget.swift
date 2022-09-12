//
//  ShelterMapWidget.swift
//  ShelterMapWidget
//
//  Created by @Ryan on 2022/9/5.
//

import WidgetKit
import SwiftUI
import Intents
import Foundation

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), speed: 30, userPositionLatitude: 24.33, userPositionLongitude: 120.12, nearestShelter: ShelterWidget(category: "大樓", address: "避難場所地址", underFloor: "1", capacity: "100", distance: 50, totalCount: 30), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), speed: 30, userPositionLatitude: 24.33, userPositionLongitude: 120.12, nearestShelter: ShelterWidget(category: "大樓", address: "避難場所地址", underFloor: "1", capacity: "100", distance: 50, totalCount: 30), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let speed = UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.integer(forKey: "speedInt")
        let userPositionLatitude = UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.double(forKey: "userPositionLatitude")
        let userPositionLongitude = UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.double(forKey: "userPositionLongitude")
        
        let nearestCategory = UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.string(forKey: "nearestCategory") ?? "大樓"
        let nearestAddress = UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.string(forKey: "nearestAddress") ?? "避難場所地址"
        let nearestUnderFloor = UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.string(forKey: "nearestUnderFloor") ?? "1"
        let nearestCapacity = UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.string(forKey: "nearestCapacity") ?? "100"
        let nearestDistance = UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.integer(forKey: "nearestDistance")
        let totalCount = UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.integer(forKey: "totalCount")

        
        let currentDate = Date()
        
        for minuteOffset in 1 ..< 20 {
            guard let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset * 3, to: currentDate) else {
                continue
            }
            let entry = SimpleEntry(date: entryDate, speed: speed, userPositionLatitude: userPositionLatitude, userPositionLongitude: userPositionLongitude, nearestShelter: ShelterWidget(category: nearestCategory, address: nearestAddress, underFloor: nearestUnderFloor, capacity: nearestCapacity, distance: nearestDistance, totalCount: totalCount), configuration: configuration)
            entries.append(entry)
        }
        //        for hourOffset in 0 ..< 5 {
        //            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        //            let entry = SimpleEntry(date: currentDate, speed: speed, userPositionLatitude: userPositionLatitude, userPositionLongitude: userPositionLongitude, configuration: configuration)
        //            entries.append(entry)
        //        }
        
        //        let entries = [
        //            SimpleEntry(date: Date(), speed: speed, userPositionLatitude: userPositionLatitude, userPositionLongitude: userPositionLongitude, configuration: configuration)
        //        ]
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        //        let currentDate = Date()
        //        for hourOffset in 0 ..< 5 {
        //            let entryDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        //            let entry = SimpleEntry(date: entryDate, configuration: configuration)
        //            entries.append(entry)
        //        }
        //
        //        let timeline = Timeline(entries: entries, policy: .atEnd)
        //        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let speed: Int
    let userPositionLatitude: Double
    let userPositionLongitude: Double
    let nearestShelter: ShelterWidget
    let configuration: ConfigurationIntent
}

struct ShelterWidget {
    
    var category: String = ""
    var address: String = ""
    var underFloor: String = ""
    var capacity: String = ""
    var distance: Int = 0
    var totalCount: Int = 0
}


struct ShelterMapWidgetEntryView : View {
    
    //    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    @Environment(\.colorScheme) var scheme
    
    @ViewBuilder
    var body: some View {
        
        GeometryReader { geo in
            
            if geo.size.width < UIScreen.main.bounds.width/2 {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        Image("appImage")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .padding(.horizontal ,10)
                        
                        Text("最近避難")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("darkRed"))
                        
                        
                        Text("\(entry.nearestShelter.totalCount)")
                            .font(.system(size: 9, weight: .bold))
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.white)
                            .background(Circle().foregroundColor(scheme == .dark ? Color.green.opacity(0.4) : Color("green")))
                            .padding(.leading, UIScreen.main.bounds.width > 400 ? 34 : 25)
    
                    }
                    .padding(.vertical, 10)
                    .padding([.leading, .top], 3)
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            HStack(alignment: .center, spacing: 0) {
                                
                                Text("\(entry.nearestShelter.distance)")
                                    .font(.system(size: entry.nearestShelter.distance > 99 ? 20 : 29, weight: .bold))
                                Text(" m")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.gray)
                                    .offset(x: -1, y: entry.nearestShelter.distance > 99 ? 3 : 7)
                                
                            }
                            .padding(.horizontal, 5)
                            
                            MapAnnotationViewWidget(category: entry.nearestShelter.category, capacity: entry.nearestShelter.capacity)
                                .frame(width: 50, height: 55)
                                .offset(y: 20)
                        }
                        .padding(.bottom, -1)
                        
                        Text("\(entry.nearestShelter.address)")
                            .font(.system(size: 11, weight: .bold))
                            .padding(5)
                            .padding(.horizontal, 2)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.brown.opacity(0.3)))
                        //
                        
                        
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 15).fill(.thinMaterial))
                    .padding(6)
                    .padding(.top, -2)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
                
                
            } else {
                
                HStack(spacing: 10) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack(alignment: .center, spacing: 0) {
                            
                            Image("appImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .padding(.horizontal ,10)
                            
                            Text("最近避難")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color("darkRed"))
                            
                                                        
                        }
                        .padding(.vertical, 10)
                        
                        VStack(alignment: .center) {
                            
                            HStack {
                                HStack(alignment: .center, spacing: 0) {
                                    
                                    Text("\(entry.nearestShelter.distance)")
                                        .font(.system(size: entry.nearestShelter.distance > 99 ? 20 : 29, weight: .bold))
                                    Text(" m")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(.gray)
                                        .offset(x: -1, y: entry.nearestShelter.distance > 99 ? 3 : 7)
                                    
                                }
                                .padding(.horizontal, 5)
                                
                                MapAnnotationViewWidget(category: entry.nearestShelter.category, capacity: entry.nearestShelter.capacity)
                                    .frame(width: 50, height: 50)
                                    .offset(y: 20)
                            }
                            .padding(.bottom, -1)
                            
                            Text("\(entry.nearestShelter.address)")
                                .font(.system(size: 11, weight: .bold))
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 6).fill(.brown.opacity(0.3)))

                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
                        .padding(6)
                        
                    }
                    .frame(maxWidth: geo.size.width/2 - 10, maxHeight: geo.size.width/2)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                    
                        
                    }
                    .frame(maxWidth: geo.size.width/2 - 10, maxHeight: geo.size.width/2)
                    .background(RoundedRectangle(cornerRadius: 15).fill(.ultraThinMaterial))
                    .padding(10)
                }
            }
            
        }
        .onChange(of: entry.nearestShelter.distance != UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.integer(forKey: "nearestDistance")) { newValue in
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        
    }
}

@main
struct ShelterMapWidget: Widget {
    
    let kind: String = "ShelterMapWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ShelterMapWidgetEntryView(entry: entry)
                .environment(\.widgetFamily, .systemSmall)
            
        }
        .configurationDisplayName("避難地圖捷徑")
        .description("篩選顯示最近避難場所")
        .supportedFamilies([.systemSmall])
    }
}

struct ShelterMapWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            ShelterMapWidgetEntryView(entry: SimpleEntry(date: Date(), speed: 30, userPositionLatitude: 24.33, userPositionLongitude: 120.12, nearestShelter: ShelterWidget(category: "大樓", address: "台中市中區中清路100號", underFloor: "1", capacity: "100", distance: 50), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            ShelterMapWidgetEntryView(entry: SimpleEntry(date: Date(), speed: 30, userPositionLatitude: 24.33, userPositionLongitude: 120.12, nearestShelter: ShelterWidget(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
        }
    }
}

extension WidgetFamily: EnvironmentKey {
    public static var defaultValue: WidgetFamily = .systemSmall
}

extension EnvironmentValues {
    var widgetFamily: WidgetFamily {
        get { self[WidgetFamily.self] }
        set { self[WidgetFamily.self] = newValue }
    }
}
