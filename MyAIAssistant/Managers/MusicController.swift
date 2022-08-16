//
//  MusicManager.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 16.08.2022.
//

import Foundation
import MusicKit

class MusicController: ObservableObject {
    private let currentAuthStatus = MusicAuthorization.currentStatus
    @Published var permissionAccepted: Bool?
    static let shared = MusicController()
    
    init(){
        permissionAccepted = false
        authStatus()
    }
    
    
    func requestAuthorization() async {
        _ = await MusicAuthorization.request()
    }
    
    func authStatus() {
        let status = MusicAuthorization.currentStatus
        switch status {
        case MusicAuthorization.Status.authorized:
            print("DEBUG: Apple Music granted")
            permissionAccepted = true
        case MusicAuthorization.Status.restricted:
            print("DEBUG: Apple Music not granted")
            permissionAccepted = false
        case MusicAuthorization.Status.denied :
            print("DEBUG: Apple Music not granted")
            permissionAccepted = false
        default:
            break
        }
    }
    
}
