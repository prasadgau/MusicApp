//
//  SongQuery.swift
//  MusicApp
//
//  Created by Prasad G on 3/20/18.
//  Copyright © 2018 Prasad G. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

struct SongInfo {
    
    var albumTitle: String
    var artistName: String
    var songTitle:  String
    
    var songId   :  NSNumber
}

struct AlbumInfo {
    
    var albumTitle: String
    var songs: [SongInfo]
}

class SongQuery {
    
    func get(songCategory: String) -> [AlbumInfo] {
        
        var albums: [AlbumInfo] = []
        let albumsQuery: MPMediaQuery
        if songCategory == "Artist" {
            albumsQuery = MPMediaQuery.artists()
            
        } else if songCategory == "Album" {
            albumsQuery = MPMediaQuery.albums()
            
        } else if songCategory == "Songs" {
                albumsQuery = MPMediaQuery.songs()
    
        }else {
            albumsQuery = MPMediaQuery.albums()
        }
        
        
        // let albumsQuery: MPMediaQuery = MPMediaQuery.albums()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        //  var album: MPMediaItemCollection
        
        for album in albumItems {
            
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            // var song: MPMediaItem
            
            var songs: [SongInfo] = []
            
            var albumTitle: String = ""
            
            for song in albumItems {
                if songCategory == "Artist" {
                    albumTitle = song.value( forProperty: MPMediaItemPropertyArtist ) as! String
                    
                } else if songCategory == "Album" {
                    albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String
                    
                    
                } else {
                    albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String
                }
                
                /*let songInfo: SongInfo = SongInfo(
                    albumTitle: String(describing:(song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as? String)),
                    artistName: (song.value( forProperty: MPMediaItemPropertyArtist ) as? String)!,
                    songTitle:  (song.value( forProperty: MPMediaItemPropertyTitle ) as? String)!,
                    songId:     song.value( forProperty: MPMediaItemPropertyPersistentID ) as! NSNumber
                )*/
                var albumTitleName = "No Album Title"
                var artistname = "No Artist Name"
                var songTitleName = "No Song Title"
                
                if let albumT = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as? String
                {
                    albumTitleName = albumT
                }
                if let artN = song.value( forProperty: MPMediaItemPropertyArtist ) as? String
                {
                    artistname = artN
                }
                if let songT = song.value( forProperty: MPMediaItemPropertyTitle ) as? String
                {
                    songTitleName = songT
                }
                let songInfo: SongInfo = SongInfo(
                    albumTitle: albumTitleName,
                    artistName: artistname,
                    songTitle:  songTitleName,
                    songId: song.value( forProperty: MPMediaItemPropertyPersistentID ) as! NSNumber
                )
                songs.append( songInfo )
            }
            
            let albumInfo: AlbumInfo = AlbumInfo(
                
                albumTitle: albumTitle,
                songs: songs
            )
            
            albums.append( albumInfo )
        }
        
        return albums
        
    }
    
    func getItem( songId: NSNumber ) -> MPMediaItem {
        
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        
        var items: [MPMediaItem] = query.items! as [MPMediaItem]
        
        return items[items.count - 1]
        
    }
    
}
