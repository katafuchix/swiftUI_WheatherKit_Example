//
//  ContentView.swift
//  WeatherSample
//

import SwiftUI
import WeatherKit
import CoreLocation

struct ContentView: View {
    @State var currentWeather: CurrentWeather?
    
    var body: some View {
        Form {
            if let weather = currentWeather {
                Section {
                    // 気温
                    Label(weather.temperature.formatted(), systemImage: "thermometer")
                    // 湿度
                    Label("\(Int(weather.humidity * 100))%", systemImage: "humidity.fill")
                    // 日中か夜間か
                    Label(weather.isDaylight ? "Day time" : "Night time", systemImage: weather.isDaylight ? "sun.max.fill" : "moon.stars.fill")
                } header: {
                    HStack {
                        Spacer()
                        // 天気のシンボル
                        Image(systemName: weather.symbolName)
                            .font(.system(size: 60))
                        Spacer()
                    }
                }
            }
        }
        .task {
            // 現在の気象データを取得
            await getWeather()
        }
    }
    
    func getWeather() async {
        let weatherService = WeatherService()
        let location = CLLocation(latitude: 35.6809591, longitude: 139.7673068) // 東京駅
        do {
            let weather = try await weatherService.weather(for: location, including: .current)
            currentWeather = weather
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
