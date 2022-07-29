//
//  Response.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 28.07.2022.
//

import Foundation
import SwiftUI

@MainActor
func getBotRespose(message:String, name:String) async -> String {
    var weatherManager = WeatherManager()
    @State var weather: MainResponse?
    
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("hello") || tempMessage.contains("hey") || tempMessage.contains("salut"){
        return "Hey there!"
    }
    else if tempMessage.contains("goodbye"){
        return "Talk to you later!"
    }
    else if tempMessage.contains("how are") || tempMessage.contains("what's up") || tempMessage.contains("what up") || tempMessage.contains("how you") {
        return "I am fine \(name), you?"
    }
    else if tempMessage.contains("fuck you"){
        return "Fuck you too, bitch."
    }
    else if tempMessage.contains("team"){
        return "My favorite team is Galatasaray."
    }
    else if tempMessage.count == 1 {
        return "What?"
    }
    else if tempMessage.contains("purpose"){
        return "My ultimate purpose is to help you."
    }
    else if tempMessage.contains("bad"){
        return "Sorry to hear that."
    }
    else if tempMessage.contains("good") || tempMessage.contains("fine") || tempMessage.contains("great"){
        return "Glad to hear that."
    }
    else if tempMessage.contains("weather"){
        if LocationManager.shared.permissionAccepted == false {
            LocationManager.shared.requestLocation()
            return "Requesting for permission"
        }
        else{
            print(LocationManager.shared.location)
            if let weather = weather {
                return "Weather is \(weather.temp) degrees today"
            }
            else {
                do {
                    if let location = LocationManager.shared.location {
                        weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                        return "Weather is \(weather!.temp) degrees today"
                    }
                    else {return "I am having trouble getting your location"}
                } catch {
                    return "I am having trouble getting weather data"
                }
            }
        }
    }
    
    return "I don't have an answer for that \(name)."
}

