//
//  RadioVC.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 09/02/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer

class RadioVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var radioPlayer: UIView!
    
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraintSV: NSLayoutConstraint!
    
    @IBOutlet weak var radioName: UILabel!
    
    @IBOutlet weak var playPause: UIButton!
    
    
    var selected = false
    
    var radios = [Radio]()
    var playerItem:AVPlayerItem!
    var player : AVPlayer!
    
    //Constant
    let RADIO_URL = "http://mp3quran.net/api/radio/radio_en.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        buttonConstraint.constant = 50
        topConstraintSV.constant = 50
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().rearViewRevealWidth = 140
        
        getRadioData(url: RADIO_URL)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func getRadioData(url: String){
        
        Alamofire.request(url , method: .get).responseJSON { (response) in
            
            if response.result.isSuccess {
                print("Success! Got the radios data")
                
                let radioJSON: JSON = JSON(response.result.value!)
                self.updateRadioData(json: radioJSON)
                
            } else {
                 print("Error \(response.result.error)")
            }
        }
        
    }
    
    func updateRadioData(json: JSON){
        
        for radioJSON in json["Radios"].arrayValue {
            let radio = Radio()
            radio.Name = radioJSON["Name"].stringValue
            radio.URL = radioJSON["URL"].url
            self.radios.append(radio)
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func parseURLToPlayer(url: URL) {
        
//            self.playerItem = AVPlayerItem(url: url)
//            self.player = AVPlayer(playerItem: self.playerItem)
        self.player = AVPlayer(url: url)
            self.playPauseAudio()
        
       
    }
    
    func playPauseAudio() {
        if player?.rate == 0 {
            player.play()
            player.volume = 1.0
            playPause.setImage(UIImage(named:"pause"), for: .normal)
        } else if player.rate != 0 {
            player.pause()
            player.rate = 0
            playPause.setImage(UIImage(named:"play"), for: .normal)
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "radioCell", for: indexPath) as! RadioTVCell
        
        cell.radioname.text = radios[indexPath.row].Name
        cell.radioImage.image = UIImage(named: "menuImage5")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selected = !selected
        //buttonConstraint.constant = selected ? -50 : 50
        buttonConstraint.constant = -50
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
        //topConstraintSV.constant = selected ? 0 : 50
        topConstraintSV.constant = 0
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
        parseURLToPlayer(url: radios[indexPath.row].URL!)
        radioName.text = radios[indexPath.row].Name
    }
    
    
    @IBAction func playPauseBtn(_ sender: UIButton) {
        
        playPauseAudio()
    }
    
    

}












