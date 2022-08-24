//
//  MusicManager.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 16.08.2022.
//

import Foundation
import MusicKit

struct SongResponse:Decodable {
    let data: [Song]
}

struct CatalogResponseBody:Decodable {
    let results: CatalogResponse
    
    struct CatalogResponse:Decodable {
        let songs:SongResponse
    }
}

class MusicController: ObservableObject {
    private let currentAuthStatus = MusicAuthorization.currentStatus
    @Published var permissionAccepted: Bool?
    var musicSubscription: MusicSubscription?
    
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
    
    
    func playMusic(songName:String) async -> String{
        let subscription = try? await MusicSubscription.current
        musicSubscription = subscription
        let checkCat = try? await MusicSubscription.current.canPlayCatalogContent
        print("can play catalog content: \(checkCat)")
        if checkCat == true {
            let countryCode = try! await MusicDataRequest.currentCountryCode
            let urlSongName = songName.urlSearchFormat()
            let urlString = "https://api.music.apple.com/v1/catalog/\(countryCode)/search?types=songs&term=\(urlSongName)"
            print(urlString)
            let url = URL(string: urlString)!
            
            let dataRequest = MusicDataRequest(urlRequest: URLRequest(url: url))
            let dataResponse = try? await dataRequest.response()
            
            let decoder = JSONDecoder()
            let songsResponse = try? decoder.decode(CatalogResponseBody.self, from: dataResponse!.data)
            print(songsResponse?.results.songs.data[0])
            let artistName = songsResponse?.results.songs.data[0].artistName ?? "unknown artist"
            let responseSongName = songsResponse?.results.songs.data[0].title ?? "\(songName.capitalizingFirstLetter())"
            return "Now playing \(responseSongName) by \(artistName)."
        }
        return "I cannot play \(songName)"
        /*
        let searchRequest = MusicCatalogSearchRequest(term: songName, types: [Song.self])
        guard let response = try? await searchRequest.response() else {
            print("No response from catalogue")
            return
        }
        print("catalogue found \(response.songs.count) songs")
    */
    }
    
    func playMusic(songName:String, artistName:String){
        
    }
    
}
