//
//  NetworkManager.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 25.08.2022.
//

import Foundation
import Network


class NetworkManager: ObservableObject{
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label:"NetworkManager")
    @Published var isConnected = true
    
    init(){
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    
}
