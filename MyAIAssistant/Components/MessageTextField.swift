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
    let synthesizer:AVSpeechSynthesizer
    
    var body: some View {
        HStack{
            CustomTextField(placeholder: Text("Say anything..."), text: $message)
            
            Button {
                Task{
                    if message.isEmpty != true {
                        let text = message
                        message = ""
                        messages.append(Message(id: messages.count, sender: "User", text: text))
                        print(messages.count)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                            messages.append(Message(id:messages.count, sender: "Pending", text: ""))
                        }
                        let response = await getBotRespose(message: text, name: name)
                        let utterance = AVSpeechUtterance(string: response)
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utterance.rate = 0.4
                        if (synthesizer.isSpeaking){
                                synthesizer.stopSpeaking(at: .immediate)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+3.0){
                            messages.popLast()
                            messages.append(Message(id:messages.count, sender: "AI", text: response))
                            synthesizer.speak(utterance)
                        }
                    }
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
        .background(Color("Gray"))
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
