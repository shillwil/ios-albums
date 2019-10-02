//
//  AlbumDetailTableViewController.swift
//  ios-albums
//
//  Created by Alex Shillingford on 9/30/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var albumNameTextField: UITextField!
    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var genresTextField: UITextField!
    @IBOutlet weak var coverArtUrlsTextField: UITextField!
    
    var albumController: AlbumController?
    var album: Album? {
        didSet {
            if isViewLoaded {
                updateViews()
            }
        }
    }
    
    var tempSongs: [Song] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if isViewLoaded {
            updateViews()
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let albumName = albumNameTextField.text,
            !albumName.isEmpty,
            let albumArtistName = artistNameTextField.text,
            !albumArtistName.isEmpty,
            let genres = genresTextField.text,
            !genres.isEmpty,
            let coverArt = coverArtUrlsTextField.text,
            !genres.isEmpty else { return }
        let genresArray: [String] = genres.components(separatedBy: ", ")
        let coverArtArray: [String] = coverArt.components(separatedBy: ", ")
        var coverArtURLArray: [URL] = []
        for url in coverArtArray {
            if let newURL = URL(string: url) {
                coverArtURLArray.append(newURL)
            }
        }
        
        if let album = album {
            albumController?.update(album: album, artist: albumArtistName, coverArt: coverArtURLArray, genres: genresArray, name: albumName, songs: tempSongs)
        } else {
            albumController?.createAlbum(artist: albumArtistName, coverArt: coverArtURLArray, genres: genresArray, name: albumName, songs: tempSongs)
        }
        
        navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tempSongs.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongTableViewCell else { return UITableViewCell() }
        
        if !tempSongs.isEmpty {
            cell.song = tempSongs[indexPath.row]
        }
        
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongTableViewCell else { return 100 }
        
        if cell.addSongButton.isHidden == true {
            return 146
        } else {
            return 111
        }
    }
    
    func updateViews() {
        if let album = album {
            albumNameTextField.text = album.name
            artistNameTextField.text = album.artist
            genresTextField.text = album.genres.joined(separator: ", ")
            var coverArtStrings = ""
            guard let coverArtURLS = album.coverArt else { return }
            for coverArt in coverArtURLS {
                coverArtStrings += ", \(coverArt)"
            }
            coverArtUrlsTextField.text = coverArtStrings
            tempSongs = album.songs
            self.title = album.name
        } else {
            self.title = "New Album"
        }
    }

}

extension AlbumDetailTableViewController: SongTableViewCellDelegate {
    func addSong(with title: String, duration: String) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        guard let newSong = albumController?.createSong(name: title, duration: duration) else { return }
        tempSongs.append(newSong)
        tableView.reloadData()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}
