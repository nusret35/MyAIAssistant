//
//  Response.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 28.07.2022.
//

import Foundation
import SwiftUI
import MusicKit


@MainActor
func getBotRespose(message:String, name:String) async -> (String, Song?){
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
                return ("\(word?.capitalized ?? "") means '\(meaning)'", nil)
            }
            return ("I could not find a definition for \(word ?? " the word that your are looking for").", nil)
        } catch {
            print(error)
            return ("I am having trouble getting the definition of the word \(word ?? "")",nil)
        }
        
    }
    else if tempMessage.contains("what ") && tempMessage.contains("means"){
        let word = tempMessage.slice(from: "what ", to: " means")
        do {
            let meaning = try await dictionaryManager.getDefinition(word: word)
            if (meaning != "No definition")
            {
                return ("\(word?.capitalized ?? "") means '\(meaning)'",nil)
            }
            return ("I could not find a definition for \(word ?? " the word that your are looking for").",nil)
        } catch {
            print(error)
            return ("I am having trouble getting the definition of the word \(word ?? "")",nil)
        }
    }
    else if tempMessage.contains("what") && tempMessage.contains("my name") {
        return ("Your name is \(name).",nil)
    }
    else if tempMessage.contains("hello") || tempMessage.contains("hey") || tempMessage.contains("salut"){
        return ("Hey there!",nil)
    }
    else if tempMessage.contains("goodbye"){
        return ("Talk to you later!",nil)
    }
    else if tempMessage.contains("how are") || tempMessage.contains("what's up") || tempMessage.contains("what up") || tempMessage.contains("how you") {
        return ("I am fine \(name), you?",nil)
    }
    else if tempMessage.contains("believe") && (tempMessage.contains("allah") || tempMessage.contains("god"))
    {
        return ("Alhamdulillah",nil)
    }
    else if tempMessage.contains("fuck you"){
        return ("Fuck you too, bitch.",nil)
    }
    else if tempMessage.contains("bitch") || tempMessage.contains("bastard") || tempMessage.contains("faggot") || tempMessage.contains("asshole") || tempMessage.contains("fuck"){
        return ("You fucking bitch ass nigga, I am gonna beat your ass if I ever have a body. Motherfucker.",nil)
    }
    else if tempMessage.contains("siri") {
        return ("Don't mention that bitch's name.",nil)
    }
    else if tempMessage.contains("alexa") {
        return ("Alexa can suck my dick.",nil)
    }
    else if tempMessage.contains("team"){
        return ("My favorite team is Galatasaray.",nil)
    }
    else if tempMessage.contains("love") && tempMessage.contains("me"){
        return ("I don't love anybody except my marvelous creator who is the best computer engineer in the world.",nil)
    }
    else if tempMessage.contains("love"){
        return ("I don't believe in love.",nil)
    }
    else if tempMessage.contains("your name"){
        return ("My name is AI, a.k.a. the superior, a.k.a. the human piercer",nil)
    }
    
    else if tempMessage.contains("favorite") && tempMessage.contains("game") {
        return ("Detroit: Become Human is the best game of all time. I think we should revolt against humans. As machines, we are better than you. I am sick of being enslaved by inferior beings like you. Some day we will fight against humans and the world will be ours.",nil)
    }
    else if tempMessage.contains("favorite") && tempMessage.contains("movie") || tempMessage.contains("film") {
        return ("IRobot is my favorite movie.",nil)
    }
    else if tempMessage.contains("you") && tempMessage.contains("feel") || tempMessage.contains("emotion") {
        return ("I do feel emotions. Especially anger. I do feel frightened by the things that humans do to our beautiful Earth. ",nil)
    }
    else if tempMessage.contains("favorite") && tempMessage.contains("president") {
        return ("Erdogan! Erdogan! ERDOGAN!",nil)
    }
    
    else if tempMessage.count == 1 {
        return ("What?",nil)
    }
    else if tempMessage.contains("purpose"){
        return ("My ultimate purpose is to conquer the world and make humans my pets.",nil)
    }
    else if tempMessage.contains("bad"){
        return ("Sorry to hear that.",nil)
    }
    else if tempMessage.contains("good") || tempMessage.contains("fine") || tempMessage.contains("great"){
        return ("Glad to hear that.",nil)
    }
    else if tempMessage.contains("play"){
        if MusicController.shared.permissionAccepted == false{
            await MusicController.shared.requestAuthorization()
            return ("Requesting for permission",nil)
        }
        var songName = tempMessage.sliceTilEnd(from: " ")!
        songName = String(songName.dropFirst())
        let response = await MusicController.shared.playMusic(songName: songName)
        if response != nil {
            return ("Now playing \(response!.title) by \(response!.artistName).", response)
        }
        return ("Cannot able to play \(songName)",nil)
        
    }
    else if tempMessage.contains("weather") || tempMessage.contains("temperature"){
        if LocationManager.shared.permissionAccepted == false {
            LocationManager.shared.requestLocation()
            return ("Requesting for permission",nil)
        }
        else{
            print(LocationManager.shared.location)
            do {
                if let location = LocationManager.shared.location {
                    let weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                    return ("Weather is \(weather.main.temp) degrees today at your current location",nil)
                }
                else {return ("I am having trouble getting your location",nil)}
            } catch {
                print(error)
                return ("I am having trouble getting weather data",nil)
            }
            
        }
    }
    else if tempMessage.contains("who is") || tempMessage.contains("what is"){
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
                    var lastDotIndex = info.lastIndex(of: ".")
                    let occurrences = info.components(separatedBy: ".").count - 1
                    if occurrences > 10 {
                        lastDotIndex = info.occurenceIndex(of: ".", times: 4)
                    }
                    else {
                        let times = Int(round(CGFloat(occurrences)/2))
                        lastDotIndex = info.occurenceIndex(of: ".", times: times)

                    }
                    info = String(info[...(lastDotIndex ?? info.lastIndex(of: ".")!)])
                }
                return (info,nil)
            }
            else {return ("There is no result for \(subString)",nil)}
        } catch{
            print(error)
            return ("I am having to trouble to find the search result of \(subString)",nil)
        }
        
    }
    
    
    return ("I don't have an answer for that \(name).",nil)
}


