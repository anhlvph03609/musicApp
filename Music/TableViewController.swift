//
//  TableViewController.swift
//  Music
//
//  Created by Anh Lê Việt on 10/10/16.
//  Copyright © 2016 Anh Lê Việt. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var data = UserDefaults()
    var listMusic: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = UserDefaults.standard
        get_data_from_url("http://anhlvph03609.esy.es/music.json")
        
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listMusic.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let song :Music  = listMusic[indexPath.row]
        // Configure the cell...
        let image :UIImageView = UIImageView(frame: CGRect(x:0,y:0,width:75,height:99))
        if let url  = NSURL(string :song.img),
            let data = NSData(contentsOf: url as URL)
        {
            image.image = UIImage(data: data as Data)
        }
        
        let label:UILabel = UILabel(frame : CGRect(x:90,y:0,width:250,height:20))
        let label2:UILabel = UILabel(frame : CGRect(x:90,y:25,width:250,height:20))
        let label3:UILabel = UILabel(frame : CGRect(x:90,y:50,width:250,height:20))
        label.text = song.name
        label2.text = song.artist
        label3.text = "Release Date: " + song.releaseDate
        cell.addSubview(label)
        cell.addSubview(label2)
        cell.addSubview(label3)
        cell.addSubview(image)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            listMusic.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
    
    
    func get_data_from_url(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            
            self.extract_json(data!)
            
            
        })
        
        task.resume()
        
    }
    
    
    func extract_json(_ data: Data)
    {
        
        
        let json: Any?
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch
        {
            return
        }
        
        guard let data_list = json as? NSArray else
        {
            return
        }
        
        
        if let song_list = json as? NSArray
        {
            for i in 0 ..< data_list.count
            {
                if let song_obj = song_list[i] as? NSDictionary
                {
                    if let song_name = song_obj["name"] as? String
                    {
                        if let song_atrist = song_obj["artist"] as? String
                        {
                            if let song_date = song_obj["releaseDate"] as? String
                            {
                                if let song_img = song_obj["img"] as? String
                                {
                                    if let song_link = song_obj["song_link"] as? String{
                                        let song :  Music =  Music(name: song_name,artist: song_atrist,releaseDate: song_date,img: song_img,song_link: song_link)
                                        
                                        listMusic.append(song)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})
        
    }
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var selectedIndex = self.tableView.indexPath(for: sender as! UITableViewCell)
        let select : Int! = selectedIndex?.row
        // print(select)
        let song : Music = listMusic[select]
        
        let savedData = NSKeyedArchiver.archivedData(withRootObject: song)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "song")    }
    
    
}
