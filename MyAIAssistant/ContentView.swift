import SwiftUI

final class DataModel: ObservableObject {
    static let shared = DataModel()

    @Published var name = ""
}

struct ContentView: View {
    @ObservedObject var data = DataModel.shared
    @State var nameIsEmpty = true
    @State var opacity:Double = 0
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("Please enter your name", text: $data.name)
                    .padding()
                NavigationLink(destination: AIView(name:data.name), tag: 1, selection: $selection) {
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
        }
    }
}



struct AIView: View {
    var name:String
    @State var currentMessage = ""
    var messages:[Message] = []
   
    init(){
        self.messages.append(Message(sender:"AI",text:"Hello \(name), how can I help you today?"))
    }
    
    mutating func sendMessage()
    {
        messages.append(Message(sender: "User", text: currentMessage))
    }
    var body : some View {
        NavigationView{
            VStack{
                ForEach(messages, id: \.self ) { message in
                    
                    if message.sender == "AI" {
                        AIMessageBubble(message: message.text)
                    }
                    else {
                        UserMessageBubble(message: message.text)
                    }
                }
                Spacer()
                MessageTextField(message: currentMessage, sendAction: sendMessage())
            }
        }
    }
}


