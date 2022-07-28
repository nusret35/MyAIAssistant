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
        
        VStack{
        HStack{
                Text(message)
                    .padding()
                    .background(Color("BabyBlue"))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: .trailing)
            .padding(.horizontal)

        }.frame(maxWidth:.infinity, alignment: .trailing)
            
   
        }
}

struct AIMessageBubble: View {
    var message:String
    var body: some View {
        VStack{
            HStack{
                Text(message)
                    .padding()
                    .background(Color("Gray"))
                    .tint(Color.black)
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: .leading)
            .padding(.horizontal)
            
        }.frame(maxWidth:.infinity, alignment: .leading)
        
    }
}




struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
        UserMessageBubble(message: "123176575675675")
        AIMessageBubble(message: "dgdlşkgdlfkgdlşfgkdlfgd")
        }
    }
}
