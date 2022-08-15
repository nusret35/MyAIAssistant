//
//  TypingIndicator.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 15.08.2022.
//

import SwiftUI

struct TypingIndicator: View {
    var body: some View {
        HStack{
            TypingDot()
            TypingDot()
            TypingDot()
        }
    }
}


struct TypingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        TypingIndicator()
    }
}

struct TypingDot: View{
    
    var body: some View {
        Circle()
            .frame(width: 10.0, height: 20.0)
            .foregroundColor(.gray)
    }
}
