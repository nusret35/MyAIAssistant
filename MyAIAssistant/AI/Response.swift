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
    let weatherManager = WeatherManager()
    let dictionaryManager = DictionaryManager()
    
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
            do {
                if let location = LocationManager.shared.location {
                    let weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                    return "Weather is \(weather.main.temp) degrees today"
                }
                else {return "I am having trouble getting your location"}
            } catch {
                print(error)
                return "I am having trouble getting weather data"
            }
            
        }
    }
    
    else if tempMessage.contains("what is"){
        return "Soon, I will be able to answer your question"
    }
    
    else if tempMessage.contains("what does") && tempMessage.contains("mean") {
        let word = tempMessage.slice(from: "does ", to: " mean")
        do {
            let meaning = try await dictionaryManager.getDefinition(word: word)
            if (meaning != "No definition")
            {
                return "\(word?.capitalized ?? "") means '\(meaning)'"
            }
            return "I could not find a definition for \(word ?? " the word that your are looking for")."
        } catch {
            print(error)
            return "I am having trouble getting the definition of the word \(String(describing: word))"
        }
        
    }
    else if tempMessage.contains("what ") && tempMessage.contains("means"){
        let word = tempMessage.slice(from: "what ", to: " means")
        do {
            let meaning = try await dictionaryManager.getDefinition(word: word)
            if (meaning != "No definition")
            {
                return "\(word?.capitalized ?? "") means '\(meaning)'"
            }
            return "I could not find a definition for \(word ?? " the word that your are looking for")."
        } catch {
            print(error)
            return "I am having trouble getting the definition of the word \(String(describing: word))"
        }
    }
    return "I don't have an answer for that \(name)."
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}



