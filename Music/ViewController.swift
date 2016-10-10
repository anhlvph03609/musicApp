//
//  ViewController.swift
//  Music
//
//  Created by Anh Lê Việt on 10/10/16.
//  Copyright © 2016 Anh Lê Việt. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var playTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    var data = UserDefaults()
    var player:AVPlayer!
    var song : Music = Music()
    @IBAction func stop(_ sender: AnyObject) {
        player.pause()
    }
    
    @IBAction func Start(_ sender: AnyObject) {
    
        player.play()
    }
    
    
    @IBOutlet weak var Restart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = UserDefaults.standard
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let backs  = UIBarButtonItem(title: "Back", style: .plain, target: self,action: #selector(ViewController.back))
        let defaults = UserDefaults.standard
       
                var timer = Timer.scheduledTimer(timeInterval:0.1, target: self, selector: #selector(ViewController.updateSlider), userInfo: nil, repeats: true)
        
        
        if let savedSong = defaults.object(forKey: "song") as? Data {
            song = NSKeyedUnarchiver.unarchiveObject(with: savedSong) as! Music
        }
        
        player = AVPlayer()
        let u:NSURL = NSURL(string: song.song_link)!
        player = AVPlayer(url : u as URL)
        
        
        let duration:CMTime = self.player.currentItem!.asset.duration
        let seconds:Int = Int(CMTimeGetSeconds(duration))%60
        let munites: Int = Int(CMTimeGetSeconds(duration)/60)%60
        slider.maximumValue = Float(CMTimeGetSeconds(duration))
        slider.value = Float(100)
            endTime.text = String(munites) + ":" + String(seconds)
        playTime.text = "00:00"
        
        print("value : " + String(slider.maximumValue))
        navigationItem.leftBarButtonItems = [backs]
        
        name.text = song.name
        artist.text = song.artist
        date.text = song.releaseDate
        
        if let url  = NSURL(string : song.img),
            let data = NSData(contentsOf: url as URL)
        {
            img.image = UIImage(data: data as Data)
        }
        
    }
    func back () {
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        //let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tableViewController") as! TableViewController
       // self.present(nextViewController, animated:true, completion:nil)   
    
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "tableView") as! TableViewController
        
        self.present(resultViewController, animated:true, completion:nil)
        player.pause()
          }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changeAudioTime(_ sender: AnyObject) {
        player.pause()
        print(slider.value)
        player.play()
    }
    
    func updateSlider(){
        
        let duration:CMTime = self.player.currentItem!.currentTime()
        let seconds:Int = Int(CMTimeGetSeconds(duration))%60
        let munites: Int = Int(CMTimeGetSeconds(duration)/60)%60
        slider.value = Float(CMTimeGetSeconds(duration))
      
        playTime.text = String(munites) + ":" + String(seconds)
    }
}

