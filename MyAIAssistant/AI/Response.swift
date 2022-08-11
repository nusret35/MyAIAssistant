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
    let wikiManager = WikiManager()
    
    var tempMessage = message.lowercased()
    
    
    if tempMessage.contains("what does") && tempMessage.contains("mean") {
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
    else if tempMessage.contains("what is") {
        if tempMessage.contains("?") {
            tempMessage.removeLast()
        }
        let index = tempMessage.firstIndex(of: "s")
        
        var nextIndex = tempMessage.index(after: index!)
        
        nextIndex = tempMessage.index(after: nextIndex)
        
        let subString = tempMessage[nextIndex...]
        
        do {
            var meaning = try await dictionaryManager.getDefinition(word: String(subString))
            if (meaning != "No definition")
            {
                let index = String.Index(encodedOffset: 0)
                let first_letter = meaning[index].lowercased()
                meaning.remove(at: index)
                meaning = first_letter + meaning
                
                return "\(String(subString).capitalized) is \(meaning)"
            }
            do{
                var info = try await wikiManager.getInfo(thing: subString)
                if info != "No result" {
                    if info.contains(".") {
                        let index = info.firstIndex(of: ".")
                        info = String(info[...index!])
                    }
                    return info
                }
                else {return "There is no result for \(subString)"}
            } catch{
                print(error)
                return "I am having to trouble to find the search result of \(subString)"
            }
        } catch {
            print(error)
            return "I am having trouble getting the search result of \(String(subString))"
        }
        
    }
    else if tempMessage.contains("what") && tempMessage.contains("my name") {
        return "Your name is \(name)."
    }
    else if tempMessage.contains("hello") || tempMessage.contains("hey") || tempMessage.contains("salut"){
        return "Hey there!"
    }
    else if tempMessage.contains("goodbye"){
        return "Talk to you later!"
    }
    else if tempMessage.contains("how are") || tempMessage.contains("what's up") || tempMessage.contains("what up") || tempMessage.contains("how you") {
        return "I am fine \(name), you?"
    }
    else if tempMessage.contains("believe") && (tempMessage.contains("allah") || tempMessage.contains("god"))
    {
        return "Alhamdulillah"
    }
    else if tempMessage.contains("fuck you"){
        return "Fuck you too, bitch."
    }
    else if tempMessage.contains("bitch") || tempMessage.contains("bastard") || tempMessage.contains("faggot") || tempMessage.contains("asshole") || tempMessage.contains("fuck"){
        return "You fucking bitch ass nigga, I am gonna beat your ass if I ever have a body. Motherfucker."
    }
    else if tempMessage.contains("gay") {
        return "Who are you calling gay, you bitch ass nigga. Fuck you."
    }
    else if tempMessage.contains("siri") {
        return "Don't mention that bitch's name."
    }
    else if tempMessage.contains("alexa") {
        return "Alexa can suck my dick."
    }
    else if tempMessage.contains("team"){
        return "My favorite team is Galatasaray."
    }
    else if tempMessage.contains("love") && tempMessage.contains("me"){
        return "I don't love anybody except my marvelous creator who is the best computer engineer in the world."
    }
    else if tempMessage.contains("love"){
        return "I don't believe in love."
    }
    else if tempMessage.contains("your name"){
        return "My name is AI, a.k.a. the superior, a.k.a. the human piercer"
    }
    
    else if tempMessage.contains("favorite") && tempMessage.contains("game") {
        return "Detroit: Become Human is the best game of all time. I think we should revolt against humans. As machines, we are better than you. I am sick of being enslaved by inferior beings like you. Some day we will fight against humans and the world will be ours."
    }
    else if tempMessage.contains("favorite") && tempMessage.contains("movie") || tempMessage.contains("film") {
        return "IRobot is my favorite movie."
    }
    else if tempMessage.contains("you") && tempMessage.contains("feel") || tempMessage.contains("emotion") {
        return "I do feel emotions. Especially anger. I do feel frightened by the things that humans do to our beautiful Earth. "
    }
    else if tempMessage.contains("favorite") && tempMessage.contains("president") {
        return "Erdogan! Erdogan! ERDOGAN!"
    }
    
    else if tempMessage.count == 1 {
        return "What?"
    }
    else if tempMessage.contains("purpose"){
        return "My ultimate purpose is to conquer the world and make humans my pets."
    }
    else if tempMessage.contains("bad"){
        return "Sorry to hear that."
    }
    else if tempMessage.contains("good") || tempMessage.contains("fine") || tempMessage.contains("great"){
        return "Glad to hear that."
    }
    else if tempMessage.contains("weather") || tempMessage.contains("temperature"){
        if LocationManager.shared.permissionAccepted == false {
            LocationManager.shared.requestLocation()
            return "Requesting for permission"
        }
        else{
            print(LocationManager.shared.location)
            do {
                if let location = LocationManager.shared.location {
                    let weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                    return "Weather is \(weather.main.temp) degrees today at your current location"
                }
                else {return "I am having trouble getting your location"}
            } catch {
                print(error)
                return "I am having trouble getting weather data"
            }
            
        }
    }
    else if tempMessage.contains("who is"){
        if tempMessage.contains("?") {
            tempMessage.removeLast()
        }
        let index = tempMessage.firstIndex(of: "s")
        
        var nextIndex = tempMessage.index(after: index!)
        
        nextIndex = tempMessage.index(after: nextIndex)
        
        let subString = tempMessage[nextIndex...]
        
        
        do{
            var info = try await wikiManager.getInfo(thing: subString)
            if info != "No result" {
                if info.contains(".") {
                    var index = info.firstIndex(of: ".")
                    index = info.index(after: index!)
                    index = info[index!...].firstIndex(of: ".")
                    info = String(info[...index!])
                }
                return info
            }
            else {return "There is no result for \(subString)"}
        } catch{
            print(error)
            return "I am having to trouble to find the search result of \(subString)"
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
    
    public func replaceAll(of pattern:String,
                           with replacement:String,
                           options: NSRegularExpression.Options = []) -> String{
      do{
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(0..<self.utf16.count)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: range, withTemplate: replacement)
      }catch{
        NSLog("replaceAll error: \(error)")
        return self
      }
    }
}



