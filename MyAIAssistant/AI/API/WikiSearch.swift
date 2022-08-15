//
//  PersonSearch.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 3.08.2022.
//

import Foundation

class WikiManager {
    
    func getInfo(thing:String.SubSequence) async throws -> String {
        var urlThing = thing.replacingOccurrences(of: " ", with: "%20")
        urlThing = urlThing.urlSearchFormat()
        print(urlThing)
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=\(urlThing)&utf8=&format=json"
        guard let url = URL(string: urlString) else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url:url)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let decodeData = try? JSONDecoder().decode(WikiSearchResponseBody.self, from: data) else {
            return "No result"
        }
        var title = decodeData.query.search[0].title.replaceAll(of: " ", with: "_")
        title = title.urlSearchFormat()
        print(title)
        let pageid = decodeData.query.search[0].pageid
        let titleURLString = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts&exintro=&titles=\(title)&format=json"
        title = title.replaceAll(of: "_", with: " ")
        guard let titleURL = URL(string: titleURLString) else {
            fatalError("Missing title URL")
        }
        let titleURLRequest = URLRequest(url:titleURL)
        
        let (title_data, _) = try await URLSession.shared.data(for: titleURLRequest)
        
        
        guard let decodeTitleData = try? JSONDecoder().decode(WikiTitleSearchResponseBody.self, from: title_data) else {
            return "Error while extracting"
        }
        let htmlData = Data(decodeTitleData.query.pages["\(pageid)"]!.extract.utf8)
        
        if var attributedString = try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil){
            var finalString = attributedString.string
            if finalString.first == "\n"{
                finalString.removeFirst()
            }
            finalString = finalString.attributedStringConversionFix()
            if (finalString.contains(" is ")){
                finalString = finalString.sliceTilEnd(from: " is ")!
                finalString = "\(title)\(finalString)"
            }
            print(finalString)
            return finalString
        }
            
        return "I have problems"
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
        let pages: [String:PageResponse]
        
    }
    
    struct PageResponse:Decodable{
        let extract:String
    }

}



