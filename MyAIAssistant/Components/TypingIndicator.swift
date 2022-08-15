//
//  TypingIndicator.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 15.08.2022.
//

import SwiftUI

struct TypingIndicator: View {
    
    @State private var scaleLeft = false
    @State private var scaleMiddle = false
    @State private var scaleRight = false
    
    let timer = Timer.publish(
           every: 1,       // Second
           tolerance: 0.1, // Gives tolerance so that SwiftUI makes optimization
           on: .main,      // Main Thread
           in: .common     // Common Loop
       ).autoconnect()
    

    
    var body: some View {
        VStack{
            HStack{
                    TypingDot()
                        .offset(x: 0, y: scaleLeft ? 10 : 0)
                        .animation(.easeInOut(duration: 0.5).repeatForever())
                        .onAppear() {
                            self.scaleLeft.toggle()
                        }
                
            
                    TypingDot()
                        .offset(x: 0, y: scaleMiddle ? 10 : 0)
                        .animation(.easeInOut(duration: 0.5).repeatForever())
                        .onAppear() {
                            self.scaleMiddle.toggle()
                        }
                    
                    TypingDot()
                        .offset(x: 0, y: scaleMiddle ? 10 : 0)
                        .animation(.easeInOut(duration: 0.5).repeatForever())
                        .onAppear(){
                            self.scaleRight.toggle()
                        }

            }
            .padding()
            .background(Color("Gray"))
            .tint(Color.black)
            .cornerRadius(30)
        }.frame(maxWidth:.infinity, alignment: .leading)
            .padding()
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
            .opacity(0.5)
    }
}
