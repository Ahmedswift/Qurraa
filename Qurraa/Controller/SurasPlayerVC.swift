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

class SurasPlayerVC: UIViewController {
    
    @IBOutlet weak var suraTitle: UILabel!
    @IBOutlet weak var reciterName: UILabel!
    @IBOutlet weak var rewayaType: UILabel!
    @IBOutlet weak var playAPause: UIButton!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var fullTime: UILabel!
    
     @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var volumeView: MPVolumeView!
    
    
    @IBOutlet weak var sliderItem: UISlider!
    
    
    
    
    //
    var player : AVPlayer!
    var playerItem:AVPlayerItem!
    var selectedSuraUrl: String?
    var suraID: String = ""
    var surasDict = [String: String]()
    var sortedDic: [(key: String, value: String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.addSubview(volumeView)
 DispatchQueue.main.async {
    self.parseURLToPlayer(url: self.selectedSuraUrl, suraID: self.suraID)
    self.updatePlayerView()
    self.progressUI()
    
    
        }
        
    }

    @IBAction func ppTappedBtn(_ sender: UIButton) {
        
        playPauseAudio()
    }
    
    @IBAction func forwardbtn(_ sender: Any) {
        restartUI()
        self.progressUI()
        self.updatePlayerView()
        DispatchQueue.main.async {
        self.nextSura()
        }
    }
    
    @IBOutlet weak var rewardbtn: UIButton!
    
    
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
            DispatchQueue.main.sync {
                playAPause.setImage(UIImage(named:"pause"), for: .normal)
            }
        
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
                self.playPauseAudio()
                
                
                
            }
        }
    }
    
    func updatePlayerView() {
        DispatchQueue.main.async {
            let duration: CMTime = self.playerItem.asset.duration
            print("duration: \(duration) ")
            let seconds : Int = Int(CMTimeGetSeconds(duration))%60
            let secondsText = String(format: "%02d", seconds)
            let minutesText = String(format: "%02d", Int(CMTimeGetSeconds(duration))/60%60)
            let hours: Int = Int(CMTimeGetSeconds(duration))/3600
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
        DispatchQueue.main.async {
            
        
        // track player progress
        let interval = CMTime(value: 1, timescale: 1)
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds)%60)
            let minutesString = String(format: "%02d", Int(seconds)/60%60)
            let hoursString = String(format: "%02d", Int(seconds)/3600)
            if Int(hoursString)! > 00 {
                
                self.startTime.text = "\(hoursString):\(minutesString):\(secondsString)"
            } else {
                self.startTime.text = "\(minutesString):\(secondsString)"
            }
            
            //lets move the slider thumb
            if let duration = self.player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                self.sliderItem.value = Float(seconds / durationSeconds)
            }
            
        })
        }
    }
    
    func restartUI() {
        self.suraTitle.text = ""
        self.startTime.text = "00:00"
        self.fullTime.text = "00:00"
        self.sliderItem.value = 00
    }
    
    func nextSura() {

            var ID = Int(suraID)!
        if ID < sortedDic!.count - 1 {
            ID = ID+1
            self.suraID = "\(sortedDic![ID].key)"
            self.suraTitle.text = "Sura \(sortedDic![ID].value)"
            print("suraID: \(sortedDic![ID].key)")
        } else {
            ID = 0
            self.suraID = "\(sortedDic![ID].key)"
            self.suraTitle.text = "Sura \(sortedDic![ID].value)"
        }
        
        self.parseURLToPlayer(url: self.selectedSuraUrl, suraID: self.suraID)

    }
    
    @objc func handelSliderChange() {
        
            //print(sliderItem.value)
            
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
   
}
