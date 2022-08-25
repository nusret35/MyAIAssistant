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
    @ObservedObject var networkManager = NetworkManager()
    @State var nameIsEmpty = true
    @State var opacity:Double = 0
    @State var selection: Int? = nil
    let synthesizer = AVSpeechSynthesizer()
    

    
    var body: some View {
        if networkManager.isConnected == true
        {
            NavigationView {
                VStack{
                    TextField("Please enter your name", text: $data.name)
                        .padding()
                        .accentColor(.black)
                    NavigationLink(destination: AIView(name:data.name,synthesizer:synthesizer), tag: 1, selection: $selection) {
                        Button("Let's get started", action: {
                            if data.name.isEmpty || data.name == " " || data.name == "  "{
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
        else{
            NoConnectionView()
        }
    }
}



struct AIView: View {
    var name:String
    @State var currentMessage = ""
    
    @ObservedObject var messages = Messages()
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var musicController = MusicController.shared
    @FocusState private var textFieldIsFocused: Bool
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
                                    else if message.sender == "Pending" {
                                        TypingIndicator()
                                    }
                                    else {
                                        UserMessageBubble(message: message.text)
                                    }
        
                                } .onChange(of: messages.messages.count) { _ in
                                    scrollView.scrollTo(messages.messages.count - 1)
                                }
                        }
                
                    }
                .onTapGesture {
                    textFieldIsFocused = false
                }
                MessageTextField(message: currentMessage,name:name, messages: $messages.messages,synthesizer:synthesizer )
                    .focused($textFieldIsFocused)
            }.navigationBarTitle("My Assistant 🤖")
            .onDisappear {
                if synthesizer.isSpeaking == true {
                    synthesizer.stopSpeaking(at: .immediate)
                }
            }
    }
}

struct NoConnectionView: View {
    var body: some View {
        Text("No internet connection")
    }
}


