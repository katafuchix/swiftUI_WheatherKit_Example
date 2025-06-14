//
//  ContentView.swift
//  WeatherDaySample
//

import SwiftUI
import WeatherKit
import CoreLocation

struct ContentView: View {
    @State var dayWeathers: [DayWeather] = []
    
    var body: some View {
        Form {
            ForEach(dayWeathers, id: \.self.date) { weather in
                LabeledContent {
                    // 天気
                    Text(weather.condition.description)
                    // 降水確率
                    Text("\(Int((weather.precipitationChance*100)))%")
                    // 天気のシンボル
                    Image(systemName: weather.symbolName)
                } label: {
                    // 日付
                    Text(DateFormatter.localizedString(from: weather.date, dateStyle: .long, timeStyle: .none))
                }
            }
        }
        .task {
            await getWeather()
        }
    }
    
    func getWeather() async {
        let weatherService = WeatherService()
        let location = CLLocation(latitude: 35.6809591, longitude: 139.7673068) // 東京駅
        do {
            let weather = try await weatherService.weather(for: location, including: .daily)
            print(type(of: weather))
            print(type(of: weather.forecast))
            dayWeathers = weather.forecast
        } catch {
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
