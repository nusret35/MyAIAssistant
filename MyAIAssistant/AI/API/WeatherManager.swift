//
//  WeatherAPI.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 29.07.2022.
//
import Foundation
import CoreLocation

class WeatherManager {

    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> WeatherResponse {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=067c3c954df0febdb13af83633e08cda&units=metric") else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url:url)
        
        let (data, response) = try await URLSession.shared.data(for:urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching weather data")}
        
        guard let decodedData = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
            fatalError("URL could not be decoded")
        }
        
        print("temp: \(decodedData.main.temp)")
        
        return decodedData

    }
}

struct WeatherResponse: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    
    struct CoordinatesResponse: Decodable {
        var lon:Double
        var lat:Double
    }
    
    struct WeatherResponse:Decodable {
        var id:Int
        var main:String
        var description:String
        var icon:String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Int
        }
}
