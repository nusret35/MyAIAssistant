//
//  PersonSearch.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 3.08.2022.
//

import Foundation

class WikiManager {
    
    func getInfo(thing:String.SubSequence) async throws -> String {
        let urlThing = thing.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=\(urlThing)&utf8=&format=json"
        guard let url = URL(string: urlString) else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url:url)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let decodeData = try? JSONDecoder().decode(WikiSearchResponseBody.self, from: data) else {
            return "No result"
        }
        let title = decodeData.query.search[0].title.replaceAll(of: " ", with: "_")
        let titleURLString = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts&exintro=&titles=\(title)&format=json"
        guard let titleURL = URL(string: titleURLString) else {
            fatalError("Missing title URL")
        }
        let titleURLRequest = URLRequest(url:titleURL)
        
        let (title_data, _) = try await URLSession.shared.data(for: titleURLRequest)
        
        
        
        guard let decodeTitleData = try? JSONDecoder().decode(WikiTitleSearchResponseBody.self, from: title_data) else {
            return "Error while extracting"
        }
        
        print(decodeTitleData.query.pages["extract"])

        let stringReturn = decodeData.query.search[0].snippet.replaceAll(of: "<span class=\"searchmatch\">", with: "")
        let finalString = stringReturn.replaceAll(of: "</span>", with: "")

        return finalString
    }
    
}


struct WikiSearchResponseBody:Decodable {
    
    var query:QueryResponse
    
    
    struct QueryResponse:Decodable{
        var search:[SearchResponse]
    }
    
    struct SearchResponse:Decodable {
        var title:String
        var snippet:String
        var pageid:Int
        
    }
}

struct WikiTitleSearchResponseBody:Decodable {
    
    var query:TitleQueryResponse

    
    struct TitleQueryResponse:Decodable{
        let pages: [String:[String:String]]
    }

}

/*
struct PageResponse:Encodable,Decodable {
    
    let dic: [String:String]
    
    struct Key:CodingKey, Equatable {
        static func ==(lhs: Key, rhs: Key) -> Bool {
            return lhs.stringValue == rhs.stringValue
        }
        var stringValue: String
        init(_ string:[String:String]){ self.stringValue = string}
        init?(stringValue: String) { self.init(stringValue) }
        var intValue: Int? {return nil}
        init?(intValue: Int) {return nil}
        
        init(from decoder:Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)
            
            var optionalKey = container.allKeys[0]
            if let stringValue = try? container.decode(String.self, forKey: optionalKey){
                optionalKey.stringValue = stringValue
        } else{
                print("was not able to decode the extract")
            }
        }
    }
}
    
struct ExtractResponse:Encodable,Decodable{

    var extract:String
}

*/

