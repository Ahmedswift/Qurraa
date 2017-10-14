//
//  SuraPlayerViewController.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 17/01/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer




class SuraPlayerViewController: UIViewController {
    
    @IBOutlet weak var suraTitleName: UILabel!
    
    
    @IBOutlet weak var suratitle: UILabel!
    @IBOutlet weak var reciterName: UILabel!
    @IBOutlet weak var rewayaName: UILabel!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var pause: UIButton!
    @IBOutlet weak var volumeControl: UISlider!
    
    @IBOutlet weak var sliderItem: UISlider!
    
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    
    @IBOutlet weak var volumeView: MPVolumeView!
    
    @IBOutlet weak var bottomView: UIView!
    
    var player : AVPlayer!
    var playerItem:AVPlayerItem!
    //let volumeView = MPVolumeView()
    
    var selectedSuraUrl: String?
    
    var surasDict = [String: String]()
    var suraID: String = ""
    //var suraName: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.addSubview(volumeView)
        
        pause.isHidden = true
        play.isHidden = false
        DispatchQueue.main.async {
            print(self.surasDict)
            self.getSuraData(url: self.selectedSuraUrl, suraID: self.suraID)
            self.self.updatePlayerView()
        }
        
//        DispatchQueue.main.async {
//            var completedURL = ""
//            if Int(self.suraID)! < 100 {
//                completedURL = "\(self.selectedSuraUrl!)/00\(self.suraID).mp3"
//            } else {
//                 completedURL = "\(self.selectedSuraUrl!)/\(self.suraID).mp3"
//            }
//            if let url = URL(string: completedURL) {
//
//                self.playerItem = AVPlayerItem(url: url)
//                self.player = AVPlayer(playerItem: self.playerItem)
//                 self.player.play()
//
////                print(self.player.currentItem!.currentTime().seconds)
////                 Float(self.player.currentItem!.duration.seconds)
////                let duration: CMTime = self.playerItem.asset.duration
////                let seconds : Int = Int(CMTimeGetSeconds(duration))%60
////                let secondsText = String(format: "%02d", seconds)
////                let minutes : Int = Int(CMTimeGetSeconds(duration))/60%60
////                let minutesText = String(format: "%02d", minutes)
////                let hours: Int = Int(CMTimeGetSeconds(duration))/3600
////                let hoursText = String(format: "%02d", hours)
////                self.endTime.text = "\(hoursText):\(minutesText):\(secondsText)"
////                self.sliderItem.minimumTrackTintColor = UIColor.darkGray
////                self.sliderItem.maximumTrackTintColor = .black
////
////                self.sliderItem.setThumbImage(UIImage(named: ""), for: .normal)
////                self.sliderItem.addTarget(self, action: #selector(self.handelSliderChange), for: .valueChanged)
////
////                // track player progress
////                let interval = CMTime(value: 1, timescale: 2)
////                self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
////
////                    let seconds = CMTimeGetSeconds(progressTime)
////                    let secondsString = String(format: "%02d", Int(seconds)%60)
////                    let minutesString = String(format: "%02d", Int(seconds)/60%60)
////                    let hoursString = String(format: "%02d", Int(seconds)/3600)
////                    self.startTime.text = "\(hoursString):\(minutesString): \(secondsString)"
////
////                    //lets move the slider thumb
////                    if let duration = self.player.currentItem?.duration {
////                        let durationSeconds = CMTimeGetSeconds(duration)
////                        self.sliderItem.value = Float(seconds / durationSeconds)
////                    }
////
////                })
//
//        }
//        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }catch {
            print(error)
        }
            }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    ///MARK: - Networking
    /***************************************************************/
    
    //the getSuraData method:
    func getSuraData(url: String?, suraID: String) {
        var completedURL = ""
        DispatchQueue.main.async {
        if Int(suraID)! < 100 {
            completedURL = "\(url!)/00\(suraID).mp3"
        } else {
            completedURL = "\(url!)/\(suraID).mp3"
        }
        
        if let url = URL(string: completedURL) {
            
            self.playerItem = AVPlayerItem(url: url)
            self.player = AVPlayer(playerItem: self.playerItem)
            self.player.play()
            self.play.isHidden = true
            self.pause.isHidden = false
            }
        }
    }
    ///MARK: - UpdateUI
    /***************************************************************/
    
    // the updatePlayerView method:
    func updatePlayerView() {
        DispatchQueue.main.async {
        let duration: CMTime = self.playerItem.asset.duration
        let seconds : Int = Int(CMTimeGetSeconds(duration))%60
        let secondsText = String(format: "%02d", seconds)
        let minutes : Int = Int(CMTimeGetSeconds(duration))/60%60
        let minutesText = String(format: "%02d", minutes)
        let hours: Int = Int(CMTimeGetSeconds(duration))/3600
        let hoursText = String(format: "%02d", hours)
        self.endTime.text = "\(hoursText):\(minutesText):\(secondsText)"
        self.sliderItem.minimumTrackTintColor = UIColor.darkGray
        self.sliderItem.maximumTrackTintColor = .black
        
        self.sliderItem.setThumbImage(UIImage(named: ""), for: .normal)
        self.sliderItem.addTarget(self, action: #selector(self.handelSliderChange), for: .valueChanged)
        
        // track player progress
        let interval = CMTime(value: 1, timescale: 1)
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds)%60)
            let minutesString = String(format: "%02d", Int(seconds)/60%60)
            let hoursString = String(format: "%02d", Int(seconds)/3600)
            self.startTime.text = "\(hoursString):\(minutesString): \(secondsString)"
            
            //lets move the slider thumb
            if let duration = self.player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                self.sliderItem.value = Float(seconds / durationSeconds)
            }
            
        })
        }
    }
    
    @objc func handelSliderChange() {
        print(sliderItem.value)
        
        if let duration = player.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(sliderItem.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player.seek(to: seekTime) { (completedSeek) in
                
            }
        }
      
    }

    @IBAction func playPauseBtn(_ sender: UIButton) {
        
        
        
            if sender.tag == 1 {
                
                player.play()
                player.volume = 1.0
                play.isHidden = true
                pause.isHidden = false
                
                
                
                
                
            } else if sender.tag == 2 {

                player.pause()
                play.isHidden = false
                pause.isHidden = true
        }
    }
 
    @objc func finishedPlaying(myNotification: Notification){
        
        pause.isHidden = true
        play.isHidden = false
        
        let stopedPlayerItem: AVPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seek(to: kCMTimeZero, completionHandler: nil)
        
    }
    
    @IBAction func adjustVolume(_ sender: Any) {
        print(roundf(volumeControl.value / 0.1) * 0.1 )
        if player != nil {
            player.volume = roundf(volumeControl.value / 0.1) * 0.1
            
        }
        
    }
    
    
    @IBAction func btnGoToFirstVCTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindSegueTo1", sender: nil)
    }
    
    
    func updateUI() {
        
    }
    
    @IBAction func forwardbtn(_ sender: Any) {
         player.pause()
        self.startTime.text = "00.00"
        self.endTime.text = "00.00"
        self.sliderItem.value = 0.0
        var Id: Int  = Int(suraID)!
        if Id < 114 {
            Id += 1
            print(Id)
            suraID = "\(Id)"
            let sura = self.surasDict[suraID]
            getSuraData(url: selectedSuraUrl, suraID: suraID)
            self.reciterName.text =  "Surah \(sura ?? "")"
            self.suraTitleName.text =  "Surah \(sura ?? "")"
            updatePlayerView()
            
            pause.isHidden = true
            play.isHidden = false
            
        } else {
             player.pause()
            Id = 1
            print(Id)
            suraID = "\(Id)"
            let sura = self.surasDict[suraID]
             getSuraData(url: selectedSuraUrl, suraID: suraID)
            self.reciterName.text =  "Surah \(sura ?? "")"
            self.suraTitleName.text =  "Surah \(sura ?? "")"
           
            updatePlayerView()
            
        }
        
    }
    
    
    @IBAction func rewardbtn(_ sender: Any) {
         player.pause()
        self.startTime.text = "00.00"
        self.endTime.text = "00.00"
        self.sliderItem.value = 0.0
        var Id: Int  = Int(suraID)!
        if Id < 114 && Id > 0 {
            Id -= 1
            if Id == 0 {
                Id = 1
            }
            print(Id)
            suraID = "\(Id)"
            //self.reciterName.text =  "Surah \(String(describing: self.surasDict[suraID]))"
            let sura = self.surasDict[suraID]
             getSuraData(url: selectedSuraUrl, suraID: suraID)
            self.reciterName.text =  "Surah \(sura ?? "")"
            self.suraTitleName.text =  "Surah \(sura ?? "")"
            updatePlayerView()
            
            pause.isHidden = true
            play.isHidden = false
            
        } else {
             player.pause()
            Id = 1
            print(Id)
            suraID = "\(Id)"
            let sura = self.surasDict[suraID]
            getSuraData(url: selectedSuraUrl, suraID: suraID)
            self.reciterName.text =  "Surah \(sura ?? "")"
            self.suraTitleName.text =  "Surah \(sura ?? "")"
            
            updatePlayerView()
        }
        
        
        
    }
    
   
    @IBAction func changeAudioTime(_ sender: Any) {
        
    //let playerItme: AVPlayerItem = player.currentItem!
        //var duration: Double = playerItme.currentTime().seconds
         //sliderItem.value = Float(duration)
        
        //print(duration)
        
    }
    
    
}


