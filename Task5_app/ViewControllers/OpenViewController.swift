//
//  OpenViewController.swift
//  Task5_app
//
//  Created by Tolgahan Sonmez on 7.09.2023.
//

import UIKit
import MediaPlayer

class OpenViewController: UIViewController {
    
    var selectedAppleMusicSongID: MPMediaItem?
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSelectedAppleMusicSong()
        // Do any additional setup after loading the view.
    }
    
    func playSelectedAppleMusicSong() {
        if let songID = selectedAppleMusicSongID {
            let predicate = MPMediaPropertyPredicate(value: songID, forProperty: MPMediaItemPropertyPersistentID)
            let query = MPMediaQuery(filterPredicates: [predicate])
            
            if let mediaItem = query.items?.first {
                musicPlayer.setQueue(with: MPMediaItemCollection(items: [mediaItem]))
                musicPlayer.play()
            }
        }
    }
}

