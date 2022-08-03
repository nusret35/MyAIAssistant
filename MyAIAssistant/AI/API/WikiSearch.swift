//
//  PersonSearch.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 3.08.2022.
//

import Foundation

class WikiManager {
    
    func getInfo(thing:String) async throws -> String {
        let urlThing = thing.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=\(urlThing)&utf8=&format=json"
        guard let url = URL(string: urlString) else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url:url)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard var decodeData = try? JSONDecoder().decode(WikiSearchResponseBody.self, from: data) else {
            return "No result"
        }
        decodeData.search[0].snippet.replaceAll("<span class=\"searchmatch\">")

        return decodeData.search[0].snippet
    }
    
}


struct WikiSearchResponseBody:Decodable {
    var search:[SearchResponse]
    
    struct SearchResponse:Decodable {
        var snippet:String
    }
}


