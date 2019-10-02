// MARK: - AlbumController Class
//  AlbumController.swift
//  ios-albums
//
//  Created by Alex Shillingford on 9/30/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
// MARK: - Enums/HTTPMethods
enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class AlbumController {
    
    // MARK: - Properties
    static let shared = AlbumController()
    var albums: [Album] = []
    let baseURL = URL(string: "https://shillingford-ios-albums.firebaseio.com/")!
    
    // MARK: - Network Methods: GET
    func getAlbums(completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error performing GET request in data task on line \(#line) in file \(#file): \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error GETting data from Firebase on line \(#line) in file \(#file)")
                completion(nil)
                return
            }
            
            do {
                self.albums = try JSONDecoder().decode([String: Album].self, from: data).map({ $0.value })
            } catch {
                NSLog("Error fetching albums from Firebase on line \(#line) in file \(#file): \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    // MARK: - Network: (technically) POST
    func createAlbum(artist: String, coverArt: [URL], genres: [String], id: String = UUID().uuidString, name: String, songs: [Song]) {
        let newAlbum = Album(artist: artist, coverArt: coverArt, genres: genres, id: id, name: name, songs: songs)
        albums.append(newAlbum)
        put(album: newAlbum)
    }
    
    // MARK: - Network: PUT
    func put(album: Album) {
        let requestURL = baseURL.appendingPathComponent(album.id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(album)
        } catch {
            NSLog("Error encoding album for Firebase on line \(#line) in file \(#file): \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTting movie on line \(#line) in file \(#file): \(error)")
                return
            }
        }.resume()
    }
    
    // MARK: - Network: UPDATE album
    func update(album: Album, artist: String, coverArt: [URL], genres: [String], name: String, songs: [Song]) {
        var updatedAlbum = album
        updatedAlbum.artist = artist
        updatedAlbum.coverArt = coverArt
        updatedAlbum.genres = genres
        updatedAlbum.name = name
        updatedAlbum.songs = songs
        
        put(album: updatedAlbum)
    }
    
    // MARK: - Create New Song
    func createSong(id: String = UUID().uuidString, name: String, duration: String) -> Song {
        let newSong = Song(id: id, name: name, duration: duration)
        return newSong
    }
    
    // MARK: - JSON Codable test methods
//    func testDecodingExampleAlbum() {
//        let url = URL(fileReferenceLiteralResourceName: "exampleAlbum.json")
//        let data = try! Data(contentsOf: url)
//
//        let album = try! JSONDecoder().decode(Album.self, from: data)
//
//        print(album)
//    }
//
//    func testEncodingExampleAlbum() {
//        createAlbum(artist: "Megadeth", coverArt: [], genres: ["Thrash Metal"], name: "Countdown to Extinction", songs: [Song(name: "Symphony of Destruction", duration: "4:06")])
//    }
}
