//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by Prasad G on 3/20/18.
//  Copyright © 2018 Prasad G. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: UIViewController {

    @IBOutlet weak var currentItemArtworkImageView: UIImageView!
    @IBOutlet weak var currentItemTitleLabel: UILabel!
    @IBOutlet weak var currentItemAlbumLabel: UILabel!
    @IBOutlet weak var currentItemArtistLabel: UILabel!
    
    @IBOutlet weak var skipToPreviousItemButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var skipToNextItemButton: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    var selectedSectionNo: Int = 0
    var selectedRowNo: Int = 0
    var maxSectionsNo : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.maxSectionsNo = self.albums.count
        self.prepareMethod()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction Methods
    @IBAction func handleUserDidPressBackwardButton(_ sender: Any)
    {
        if self.selectedSectionNo >= 0
        {
            if self.selectedRowNo == 0 && self.selectedSectionNo > 0
            {
                self.selectedSectionNo = self.selectedSectionNo - 1
                self.selectedRowNo = self.albums[self.selectedSectionNo].songs.count - 1
                self.prepareMethod()
            }
            else
            {
                if self.selectedRowNo > 0
                {
                    self.selectedRowNo = self.selectedRowNo - 1
                    self.prepareMethod()
                }
                
            }
            
        }
    }
    @IBAction func handleUserDidPressPlayPauseButton(_ sender: Any)
    {
        self.audioPlayPauseMethod()
    }
    @IBAction func handleUserDidPressForwardButton(_ sender: Any)
    {
        //print("handleUserDidPressForwardButton")
        if self.selectedSectionNo < self.maxSectionsNo
        {
            let noOfRowsAtSection = self.albums[self.selectedSectionNo].songs.count
            if self.selectedRowNo < noOfRowsAtSection - 1
            {
                self.selectedRowNo = self.selectedRowNo + 1
                self.prepareMethod()
            }
            else
            {
                if  self.maxSectionsNo != (self.selectedSectionNo + 1)
                {
                    self.selectedSectionNo = self.selectedSectionNo + 1
                    self.selectedRowNo = 0
                    self.prepareMethod()
                }
                
            }
            
        }
    }
    
    //MARK: - Custom Methods
    func prepareMethod()
    {
        self.currentItemTitleLabel.text = albums[self.selectedSectionNo].songs[self.selectedRowNo].songTitle
        self.currentItemAlbumLabel.text = albums[self.selectedSectionNo].songs[self.selectedRowNo].albumTitle
        self.currentItemArtistLabel.text = albums[self.selectedSectionNo].songs[self.selectedRowNo].artistName
        let songId: NSNumber = albums[self.selectedSectionNo].songs[self.selectedRowNo].songId
        let item: MPMediaItem = songQuery.getItem( songId: songId )
        
        if  let imageSound: MPMediaItemArtwork = item.value( forProperty: MPMediaItemPropertyArtwork ) as? MPMediaItemArtwork {
            self.currentItemArtworkImageView.image = imageSound.image(at: CGSize(width: self.currentItemArtworkImageView.frame.size.width, height: self.currentItemArtworkImageView.frame.size.height))
        }
        else
        {
            self.currentItemArtworkImageView.image = UIImage.init(named: "music")
        }
        let itemUrl = item.value(forProperty: MPMediaItemPropertyAssetURL) as? NSURL
        self.prepareToPlay(itemUrl: itemUrl!)
        self.skipToNextItemButton.isEnabled = true
        self.skipToPreviousItemButton.isEnabled = true
        
        if self.selectedSectionNo == 0 && self.selectedRowNo == 0
        {
            self.skipToPreviousItemButton.isEnabled = false
        }
        if self.selectedSectionNo == (maxSectionsNo-1)
        {
            let noOfRowsAtSection = self.albums[self.selectedSectionNo].songs.count
            if self.selectedRowNo == (noOfRowsAtSection-1)
            {
                self.skipToNextItemButton.isEnabled = false
            }
            
        }
    }
    
    //MARK: - AVAudioPlayer Methods
    func prepareToPlay(itemUrl:NSURL)
    {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: itemUrl as URL)
            //audio?.delegate = self
            guard let player = self.audioPlayer else { return }
            player.prepareToPlay()
            player.play()
            self.playPauseButton.setImage(UIImage.init(named: "Pause"), for: .normal)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func audioStopToPlay()
    {
        if self.audioPlayer != nil
        {
            if (self.audioPlayer?.isPlaying)!
            {
                self.audioPlayer?.stop()
            }
            
        }
    }
    func audioPauseMethod()
    {
        if self.audioPlayer != nil
        {
            if (self.audioPlayer?.isPlaying)!
            {
                self.audioPlayer?.pause()
            }
            
        }
    }
    func audioPlayMethod()
    {
        if self.audioPlayer != nil
        {
            self.audioPlayer?.play()
        }
    }
    func audioPlayPauseMethod()
    {
        if self.audioPlayer != nil
        {
            if self.audioPlayer?.isPlaying == true
            {
                self.audioPlayer?.pause()
                self.playPauseButton.setImage(UIImage.init(named: "Play"), for: .normal)
            }
            else
            {
                self.audioPlayer?.play()
                self.playPauseButton.setImage(UIImage.init(named: "Pause"), for: .normal)
            }
        }
    }

}
