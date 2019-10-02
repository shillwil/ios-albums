//
//  SongTableViewCell.swift
//  ios-albums
//
//  Created by Alex Shillingford on 9/30/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

protocol SongTableViewCellDelegate {
    func addSong(with title: String, duration: String)
}

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var songTitleTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var addSongButton: UIButton!
    
    var song: Song?
    var delegate: SongTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addSong(_ sender: UIButton) {
        guard let title = songTitleTextField.text,
            !title.isEmpty,
            let duration = durationTextField.text,
            !duration.isEmpty else { return }
            
        delegate?.addSong(with: title, duration: duration)
    }
    
    func updateViews() {
        if let song = song {
            songTitleTextField.text = song.name
            durationTextField.text = song.duration
            addSongButton.isHidden = true
        } else {
            prepareForReuse()
        }
    }
    
    override func prepareForReuse() {
        songTitleTextField.text = ""
        durationTextField.text = ""
        addSongButton.isHidden = false
    }
    

}
