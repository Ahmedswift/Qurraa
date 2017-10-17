//
//  SurasPlayerVC.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 22/01/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class SurasPlayerVC: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var suraTitle: UILabel!
    @IBOutlet weak var reciterName: UILabel!
    @IBOutlet weak var rewayaType: UILabel!
    @IBOutlet weak var playAPause: UIButton!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var fullTime: UILabel!
    
     @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var volumeView: MPVolumeView!
    
    
    @IBOutlet weak var sliderItem: UISlider!
    
    @IBOutlet weak var suraView: UIView!
    
    
    
    //
    var player : AVPlayer!
    var playerItem:AVPlayerItem!
    var selectedSuraUrl: String?
    var timeObserverToken: Any?
    
    var suraID: String = ""
    var reciterNameS: String = ""
    var rewaya: String = ""
    var currentSuras = [Sura]()
    var index = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
 DispatchQueue.main.async {
    self.rewayaType.text = self.rewaya
    self.parseURLToPlayer(url: self.selectedSuraUrl, suraID: self.suraID)

        }
    }
    
    
    @IBAction func gestureTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "CustomSuras", sender: self)
        
       
    }
    

    @IBAction func ppTappedBtn(_ sender: UIButton) {
        
        playPauseAudio()
    }
    
    @IBAction func forwardbtn(_ sender: Any) {
        if player != nil {
            player.pause()
            player.rate = 0
            playAPause.setImage(UIImage(named:"play"), for: .normal)
            player.removeTimeObserver(timeObserverToken!)
        }
        self.nextSura()
        //self.restartUI()
        self.updatePlayerView()
    }
    
    
    
    @IBAction func rewardbtn(_ sender: Any) {
        if player != nil {
            player.pause()
            player.rate = 0
            playAPause.setImage(UIImage(named:"play"), for: .normal)
            player.removeTimeObserver(timeObserverToken!)
        }
        self.prevesSura()
        //self.restartUI()
    }
    
    
    @IBAction func btnGoToFirstVCTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindSegueTo1", sender: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    func playPauseAudio() {
        if player?.rate == 0 {
        player.play()
        player.volume = 1.0
            playAPause.setImage(UIImage(named:"pause"), for: .normal)
            
        
        } else if player.rate != 0 {
            player.pause()
            playAPause.setImage(UIImage(named:"play"), for: .normal)
            player.rate = 0
            
        }
        
    }
   
    
    func parseURLToPlayer(url: String?, suraID: String) {
        
        DispatchQueue.global().async {
            var completedURL: String = ""
           if Int(suraID)! < 10 {
            completedURL = "\(url!)/00\(suraID).mp3"
           } else if Int(suraID)! >= 10 && Int(suraID)! < 100 {
            completedURL = "\(url!)/0\(suraID).mp3"
           } else {
            completedURL = "\(url!)/\(suraID).mp3"
            }
            
            
            if let url = URL(string: completedURL) {

                self.playerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: self.playerItem)
                DispatchQueue.main.sync {
                    self.playPauseAudio()
                }
                self.progressUI()
                self.updatePlayerView()
                
                
            }
        }
    }
    
    func updatePlayerView() {
        DispatchQueue.main.async {
            let duration: CMTime = self.playerItem.asset.duration
            let seconds = CMTimeGetSeconds(duration)
            let secondsText = String(format: "%02d", Int(seconds)%60)
            let minutesText = String(format: "%02d", Int(seconds)/60%60)
            let hours: Int = Int(seconds)/3600
            let hoursText = String(format: "%02d", hours)
            
            if hours > 00 {
                self.fullTime.text = "\(hoursText):\(minutesText):\(secondsText)"
            } else {
                self.fullTime.text  = "\(minutesText):\(secondsText)"
            }
            
            self.sliderItem.setThumbImage(UIImage(named: ""), for: .normal)
            self.sliderItem.addTarget(self, action:
                #selector(self.handelSliderChange), for: .valueChanged)
            
        }
    }
    
    
    
    func progressUI() {
        // track player progress
        let interval = CMTime(value: 1, timescale: 1)
        
         timeObserverToken =   self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds)%60)
            let minutesString = String(format: "%02d", Int(seconds)/60)
            let hoursString = String(format: "%02d", Int(seconds)/3600)
            if Int(hoursString)! > 00 {
                
                self.startTime.text = "\(hoursString):\(minutesString):\(secondsString)"
            } else {
                self.startTime.text = "\(minutesString):\(secondsString)"
            }
            
            //lets move the slider thumb
             let duration = self.playerItem.asset.duration
                let durationSeconds = CMTimeGetSeconds(duration)
            
                self.sliderItem.value = Float(seconds / durationSeconds)
            
            
        })
        
    }
    
//    func restartUI() {
//        self.suraTitle.text = ""
//        self.startTime.text = "00:00"
//        self.fullTime.text = "00:00"
//
//    }
    
    
    func nextSura() {
        if index < currentSuras.count - 1 {
            index = index+1
        } else {
            index = 0
        }
        self.suraID = currentSuras[index].id!
        self.suraTitle.text = "Sura \(currentSuras[index].name!)"
        
        self.parseURLToPlayer(url: self.selectedSuraUrl, suraID: self.suraID)
        DispatchQueue.main.async {
            self.progressUI()
            self.updatePlayerView()
        }
    }
    
    func prevesSura() {
        
        if index < currentSuras.count - 1  && index != 0 {
            index = index-1
        } else if index == 0 {
            index = currentSuras.count - 1
        } else {
            index = 0
        }
        self.suraID = currentSuras[index].id!
        
        self.suraTitle.text = "Sura \(currentSuras[index].name!)"
        
        self.parseURLToPlayer(url: self.selectedSuraUrl, suraID: self.suraID)
        DispatchQueue.main.async {
            self.progressUI()
            self.updatePlayerView()
        }
    }
    
    @objc func handelSliderChange() {
        
        
            if let duration = player.currentItem?.duration {
                let totalSeconds = CMTimeGetSeconds(duration)
                let value = Float64(sliderItem.value) * totalSeconds
                
                let seekTime = CMTime(value: Int64(value), timescale: 1)
                
                player.seek(to: seekTime) { (completedSeek) in
                    
                }
            }
    }
    
    @objc func finishedPlaying(myNotification: Notification){
        
        playAPause.setImage(UIImage(named:"play"), for: .normal)
        player.rate = 0
        let stopedPlayerItem: AVPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seek(to: kCMTimeZero, completionHandler: nil)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomSuras" {
            let destinationController = segue.destination as! SurasVC
            
            destinationController.currentSura = currentSuras
            destinationController.reciterName = reciterNameS
            destinationController.rewaya = rewaya
            
            
            
        }
    }
    
   
}






