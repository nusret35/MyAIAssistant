import SwiftUI
import CoreLocationUI
import AVFoundation


final class DataModel: ObservableObject {
    static let shared = DataModel()

    @Published var name = ""
}

class Messages: ObservableObject {

    @Published var messages:[Message] = []
}

struct ContentView: View {
    @ObservedObject var data = DataModel.shared
    @State var nameIsEmpty = true
    @State var opacity:Double = 0
    @State var selection: Int? = nil
    let synthesizer = AVSpeechSynthesizer()
    
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("Please enter your name", text: $data.name)
                    .padding()
                    .accentColor(.black)
                NavigationLink(destination: AIView(name:data.name,synthesizer:synthesizer), tag: 1, selection: $selection) {
                    Button("Let's get started", action: {
                        if data.name.isEmpty {
                            opacity = 1
                        }
                        else {
                            opacity = 0
                            selection = 1
                        }
                    }
                )
                    .padding()
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .foregroundColor(Color.white)
            }
                Text("Please enter a name").opacity(opacity)
                    .foregroundColor(Color.red)
            }
        }.accentColor(.blue)
    }
}



struct AIView: View {
    var name:String
    @State var currentMessage = ""
    
    @ObservedObject var messages = Messages()
    @ObservedObject var locationManager = LocationManager.shared
    let synthesizer:AVSpeechSynthesizer
    
    
    init(name: String, synthesizer:AVSpeechSynthesizer) {
        self.name = name
        self.synthesizer = synthesizer
        messages.messages.append(Message(id: 0, sender: "AI", text: "Hello \(name), how may I help you?"))
    }

    var body : some View {
            VStack{
                ScrollView {
                    ScrollViewReader{ scrollView in
                                ForEach(messages.messages) { message in
                                    if message.sender == "AI" {
                                        AIMessageBubble(message: message.text)
                                        
                                    }
                                    else {
                                        UserMessageBubble(message: message.text)
                                    }
        
                                } .onChange(of: messages.messages.count) { _ in
                                    scrollView.scrollTo(messages.messages.count - 1)
                                }
                        }
                
                    }
                MessageTextField(message: currentMessage,name:name, messages: $messages.messages,synthesizer:synthesizer )
            }.navigationBarTitle("My Assistant 🤖")
    }
}


