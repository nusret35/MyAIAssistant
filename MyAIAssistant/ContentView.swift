import SwiftUI

final class DataModel: ObservableObject {
    static let shared = DataModel()

    @Published var name = ""
}


struct ContentView: View {
    @ObservedObject var data = DataModel.shared
    @State var nameIsEmpty = true
    @State var opacity:Double = 0
    @State var boolCheck = false
    func navigateToNextView() -> Bool{
        if nameIsEmpty {
            opacity = 1
            return false
        }
        else {
            return true
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("Please enter your name", text: $data.name)
                NavigationLink("Let's get started", destination: AIView(name: data.name), isActive: Binding<Bool>(get: {boolCheck}, set: { boolean in
                    if nameIsEmpty {
                        opacity = 1
                        boolCheck = false
                    }
                    else {
                        boolCheck = true
                    }
                }))
                Text("Please enter a name").opacity(opacity).foreground(Color.red)
                
            }
        }
    }
}


struct DogView: View {
    let index: Int
    var body : some View {
            Text("dog\(index)")
        
    }
}


struct AIView: View {
    let name: String
    @State var currentRequest = ""
    var body : some View {
        VStack{
            Text("Hello \(name), how can I help you today?")
            Spacer()
            TextField("", text: $currentRequest)
        }
    }
}
