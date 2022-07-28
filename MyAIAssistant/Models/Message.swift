//
//  Message.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 28.07.2022.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
}
