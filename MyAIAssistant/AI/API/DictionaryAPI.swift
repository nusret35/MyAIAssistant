//
//  DictionaryAPI.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 30.07.2022.
//

import Foundation

class DictionaryManager {
    
    func getDefinition(word:String?) async throws -> String {
        let urlWord = word?.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(urlWord ?? "lost")"
        guard let url = URL(string: urlString) else {
            
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url:url)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let decodeData = try? JSONDecoder().decode([DefinitionResponseBody].self, from: data) else {
            guard (try? JSONDecoder().decode(NoDefinitionResponseBody.self, from: data)) != nil
                else {
                    fatalError("URL could not be decoded")
                }
            return "No definition"
        }
        
        return decodeData[0].meanings[0].definitions[0].definition
        
    }
}

struct DefinitionResponseBody: Decodable {
    
    var word:String
    var meanings: [MeaningResponse]
    
    struct MeaningResponse:Decodable {
        var definitions: [DefinitionResponse]
    }
    
    struct DefinitionResponse: Decodable {
        var definition: String
    }
}

struct NoDefinitionResponseBody: Decodable {
    var title:String
}
