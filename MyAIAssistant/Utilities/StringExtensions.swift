//
//  StringExtensions.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 12.08.2022.
//

import Foundation

extension String {
    public func urlSearchFormat() -> String {
        var text = self
        text = text.replaceAll(of: "ü", with: "%C3%BC")
        text = text.replaceAll(of: "Ü", with: "%C3%9C")
        text = text.replaceAll(of: "ı", with: "%C4%B1")
        text = text.replaceAll(of: "İ", with: "%C4%B0")
        text = text.replaceAll(of: "ö", with: "%C3%B6")
        text = text.replaceAll(of: "Ö", with: "%C3%96")
        text = text.replaceAll(of: "ş", with: "%C5%9F")
        text = text.replaceAll(of: "Ş", with: "%C5%9E")
        text = text.replaceAll(of: "ç", with: "%C3%A7")
        text = text.replaceAll(of: "Ç", with: "%C3%87")
        text = text.replaceAll(of: "ğ", with: "%C4%9F")
        text = text.replaceAll(of: "Ğ", with: "%C4%9E")
        return text
    }
    
    public func attributedStringConversionFix() -> String {
        var text = self
        text = text.replaceAll(of: "Ã¼", with: "ü")
        text = text.replaceAll(of: "Ã¢", with: "â")
        text = text.replaceAll(of: "Ä±", with: "ı")
        text = text.replaceAll(of: "â€“", with: "-")
        text = text.replaceAll(of: "Ã§", with: "ç")
        text = text.replaceAll(of: "Ã–", with: "Ö")
        text = text.replaceAll(of: "Ã¶", with: "ö")
        text = text.replaceAll(of: "ÄŸ", with: "ğ")
        text = text.replaceAll(of: "Ã‡", with: "Ç")
        text = text.replaceAll(of: "Ä°", with: "İ")
        text = text.replaceAll(of: "Â", with: " ")
        return text
    }
    
    public func occurenceIndex(of:Character, times:Int) -> String.Index {
        let text = self
        var i = 0
        var index = text.index(text.startIndex, offsetBy: i)
        var occurence = 0
        while(occurence != times) {
            if text[index] == of {
                occurence+=1
            }
            i+=1
            index = text.index(text.startIndex, offsetBy: i)
        }
        return index
    }
}
