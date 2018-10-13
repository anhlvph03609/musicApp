//
//  Music.swift
//  Music
//
//  Created by Anh Lê Việt on 10/10/16.
//  Copyright © 2016 Anh Lê Việt. All rights reserved.
//

import Foundation
class Music : NSObject,NSCoding {
    var name :String = "eee"
    var artist : String = " "
    var releaseDate : String = "jhjhjhjh jhsjdhasjdhsa sadasdas"
    var img : String = ""
    var song_link  = ""
    override init() {
        
    }
    
    init(name:String,artist:String,releaseDate:String,img:String,song_link:String){
        self.name = name
        self.artist = artist
        self.releaseDate = releaseDate
        self.img = img
        self.song_link = song_link
    }
    
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        artist = aDecoder.decodeObject(forKey: "artist") as! String
        releaseDate = aDecoder.decodeObject(forKey : "releaseDate") as! String
        img = aDecoder.decodeObject(forKey : "img") as! String
        song_link = aDecoder.decodeObject(forKey : "song_link") as! String
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(img, forKey: "img")
        aCoder.encode(artist, forKey :"artist")
        aCoder.encode(releaseDate, forKey : "releaseDate")
        aCoder.encode(song_link,forKey : "song_link")
    }}
