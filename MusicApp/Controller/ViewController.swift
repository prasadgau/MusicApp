//
//  ViewController.swift
//  MusicApp
//
//  Created by Prasad G on 3/19/18.
//  Copyright © 2018 Prasad G. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var songsTableView: UITableView!
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.songsTableView.delegate = self
        self.songsTableView.dataSource = self
        self.songsTableView.register(UINib.init(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        
        self.audioSettingMethod()
        self.getSongsFromMediaLibrary()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Initialize Methods
    func audioSettingMethod()
    {
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch let error
        {
            print("Error:\(error)")
        }
        do
        {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error
        {
            print("Error:\(error)")
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    func getSongsFromMediaLibrary()
    {
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.albums = self.songQuery.get(songCategory: "Songs")
                //print("Albums:\(self.albums)")
                if self.albums.count == 0
                {
                    self.showAlertMethod()
                }
                else
                {
                    DispatchQueue.main.async {
                       // self.songsTableView?.rowHeight = UITableViewAutomaticDimension;
                       // self.songsTableView?.estimatedRowHeight = 60.0;
                        self.songsTableView?.reloadData()
                    }
                }
            } else {
                self.displayMediaLibraryError()
            }
        }
    }
    func displayMediaLibraryError() {
        
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }
        
        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        present(controller, animated: true, completion: nil)
    }
    func showAlertMethod()
    {
        let controller = UIAlertController(title: "", message: "No songs are there in Apple Music App. Please add songs in Apple Music App", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    //MARK: - UITableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
    }
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int  {
        
        return albums[section].songs.count
    }
    func tableView( _ tableView: UITableView, cellForRowAt indexPath:IndexPath ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SongTableViewCell",
            for: indexPath) as! SongTableViewCell
        cell.musicTitleLabel.text = albums[indexPath.section].songs[indexPath.row].songTitle
        cell.musicDescLabel.text = albums[indexPath.section].songs[indexPath.row].artistName
        let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
        let item: MPMediaItem = songQuery.getItem( songId: songId )
        
        if  let imageSound: MPMediaItemArtwork = item.value( forProperty: MPMediaItemPropertyArtwork ) as? MPMediaItemArtwork {
            cell.musicImageView.image = imageSound.image(at: CGSize(width: cell.musicImageView.frame.size.width, height: cell.musicImageView.frame.size.height))
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return albums[section].albumTitle
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc  = STORYBOARD.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        vc.selectedSectionNo = indexPath.section
        vc.selectedRowNo = indexPath.row
        vc.albums = self.albums
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

