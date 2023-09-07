//
//  SoundSelectionViewController.swift
//  Task5_app
//
//  Created by Tolgahan Sonmez on 1.09.2023.
//

import UIKit
import AVFoundation
import MusicKit
import MediaPlayer

protocol SoundSelectionDelegate: AnyObject {
    func didSelectSound(_ soundName: String)
}

class SoundSelectionViewController: UIViewController {
    
    @IBOutlet weak var soundTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    var audioPlayer: AVAudioPlayer?
    var localSounds : [LocalSongs] = []
    var applePlaylists: [String] = []
    var appleSongs: [String] = []
    
    var downloadedSongs: [MPMediaItem] = []
    
    weak var delegate: SoundSelectionDelegate?
    
    var selectedAppleMusicSongID: MPMediaItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Alarm"
        downloadedSongs = fetchDownloadedSongs()
        soundTableView.delegate = self
        soundTableView.dataSource = self
        configureLocalSongs()
        getUserPlaylists()
        getUserSongs()
    }
    
    func fetchDownloadedSongs() -> [MPMediaItem] {
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(value: true), forProperty: MPMediaItemPropertyIsCloudItem))
        return query.items ?? []
    }
    
    func playSongs()  {
        musicPlayer.setQueue(with: MPMediaItemCollection(items: downloadedSongs))
        musicPlayer.play()
    }
    
    func getUserSongs() {
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(value: true), forProperty: MPMediaItemPropertyIsCloudItem))
        
        if let downloadedSongs = query.items {
            for song in downloadedSongs {
                appleSongs.append(song.title!)
                soundTableView.reloadData()
                // You can access the downloaded song details like title, artist, etc.
                if let title = song.title, let artist = song.artist {
                    print("Song Title: \(title), Artist: \(artist), Song List")
                }
            }
        }
    }
    
    func getUserPlaylists() {
        let query = MPMediaQuery.playlists()
        if let collections = query.collections {
            for collection in collections {
                if let playlistName = collection.value(forProperty: MPMediaPlaylistPropertyName) as? String {
                    print(playlistName)
                    applePlaylists.append(playlistName)
                    soundTableView.reloadData()
                }
            }
        }
    }
    
    func configureLocalSongs() {
        localSounds.append(LocalSongs(name: "Song1.mp3"))
        localSounds.append(LocalSongs(name: "Song2.mp3"))
        localSounds.append(LocalSongs(name: "Song3.mp3"))
    }
    
    func playLocalSongs(at indexPath: IndexPath) {
        guard let songURL = Bundle.main.url(forResource: localSounds[indexPath.row].name, withExtension: "mp3") else {
            print("Şarkı dosyası bulunamadı.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: songURL)
            audioPlayer?.play()
        } catch {
            print("Şarkı çalma hatası: \(error.localizedDescription)")
        }
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        soundTableView.reloadData()
    }
}

extension SoundSelectionViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return localSounds.count
        case 1: return applePlaylists.count
        case 2: return appleSongs.count
        default: break
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soundCell", for: indexPath)
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: cell.textLabel?.text = localSounds[indexPath.row].name
        case 1: cell.textLabel?.text = applePlaylists[indexPath.row]
        case 2: cell.textLabel?.text = appleSongs[indexPath.row]
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            playLocalSongs(at: indexPath)
            let selectedSound = localSounds[indexPath.row].name
            delegate?.didSelectSound(selectedSound)
            print("bildirim soundu seçildi")
        case 1: break
        case 2:
            selectedAppleMusicSongID = downloadedSongs[indexPath.row]
            //delegateAppleSound?.didSelectedAppleSound(selectedAppleMusicSongID)
            print("AppleSoundu seçildi...")
            navigationController?.popViewController(animated: true)
        default: break
        }
    }
}
