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
        var title = decodeData.query.search[0].title.replaceAll(of: " ", with: "_")
        title = title.urlSearchFormat()
        print(title)
        let pageid = decodeData.query.search[0].pageid
        let titleURLString = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts&exintro=&titles=\(title)&format=json"
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
            finalString.removeFirst()
            return finalString.attributedStringConversionFix()
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


extension String {
    public func urlSearchFormat() -> String {
        var text = self
        text = text.replaceAll(of: "ü", with: "%FC")
        text = text.replaceAll(of: "Ü", with: "%DC")
        text = text.replaceAll(of: "ı", with: "%C4%B1")
        text = text.replaceAll(of: "İ", with: "%C4%B0")
        text = text.replaceAll(of: "ö", with: "%F6")
        text = text.replaceAll(of: "Ö", with: "%D6")
        text = text.replaceAll(of: "ş", with: "%C5%9F")
        text = text.replaceAll(of: "Ş", with: "%C5%9E")
        text = text.replaceAll(of: "ç", with: "%E7")
        text = text.replaceAll(of: "Ç", with: "%C7")
        text = text.replaceAll(of: "ğ", with: "%C4%9F")
        text = text.replaceAll(of: "Ğ", with: "%C4%9E")
        return text
    }
    
    public func attributedStringConversionFix() -> String {
        var text = self
        text = text.replaceAll(of: "Ã¼", with: "ü")
        text = text.replaceAll(of: "Ã¢", with: "â")
        return text
    }
}

/*
extension String {
    
    public func htmlToText() -> String {
        var text = self
        text = text.replaceAll(of: "<p class=\"mw-empty-elt\">\n\n\n\n</p>\n<p><b>", with: "")
        text = text.replaceAll(of: "<b>", with: "")
        text = text.replaceAll(of: "</b>", with: "")
        text = text.replaceAll(of: "<i>", with: "")
        text = text.replaceAll(of: "</i>", with: "")
        return text
    }
}
*/
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

