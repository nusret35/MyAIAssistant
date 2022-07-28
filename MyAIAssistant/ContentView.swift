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
                NavigationLink(destination: AIView(name: data.name), tag: 1, selection: $selection) {
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
    let name: String
    @State var currentRequest = ""
    var body : some View {
        VStack{
            AIMessageBubble(message: "Hello \(name), how can I help you today?")
            UserMessageBubble(message:"Hey, how you doin")
            Spacer()
            MessageTextField()
        }
    }
}


