//
//  MessageBubble.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 28.07.2022.
//

import SwiftUI

struct UserMessageBubble: View {
    var message:String
    var body: some View {
        
            HStack{
                Text(message)
                    .padding()
                    .background(Color("BabyBlue"))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: .trailing)
   
        }
}

struct AIMessageBubble: View {
    var message:String
    var body: some View {
        HStack{
            Text(message)
                .padding()
                .background(Color("Gray"))
                .tint(Color.black)
                .cornerRadius(30)
        }
        .frame(maxWidth: 300, alignment: .leading)
    }
}




struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        UserMessageBubble(message: "1231")
    }
}
