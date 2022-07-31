//
//  MessageTextField.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 28.07.2022.
//

import SwiftUI
import AVFoundation

struct MessageTextField: View {
    @State var message:String = ""
    var name:String
    @Binding var messages:[Message]
    
    var body: some View {
        HStack{
            CustomTextField(placeholder: Text("Enter your request"), text: $message)
            
            Button {
                Task{
                if message != "" && message != " "
                {
                    messages.append(Message(id: messages.count, sender: "User", text: message))
                    print(messages.count)
                }
                let response = await getBotRespose(message: message, name: name)
                let utterance = AVSpeechUtterance(string: response)
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterance.rate = 0.4
                let synthesizer = AVSpeechSynthesizer()
                DispatchQueue.main.asyncAfter(deadline: .now()+3.0){
                    messages.append(Message(id:messages.count, sender: "AI", text: response))
                    synthesizer.speak(utterance)
                }
                message = ""
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(50)
            }

        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("BabyBlue"))
        .cornerRadius(50)
        .padding()
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading){
            if text.isEmpty{
                placeholder.opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .accentColor(Color.black)
        }
    }
}
/*
struct MessageTextField_Previews: PreviewProvider {
    static var previews: some View {
        MessageTextField(sendAction: {})
    }
}
*/
