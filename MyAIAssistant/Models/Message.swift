//
//  Message.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 28.07.2022.
//

import Foundation

struct Message: Hashable, Identifiable {
    var id:Int
    var sender: String
    var text: String
}
