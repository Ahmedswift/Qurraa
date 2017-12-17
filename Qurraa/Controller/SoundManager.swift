////
////  SoundManager.swift
////  Qurraa
////
////  Created by Ahmad Ahrbi on 04/03/1439 AH.
////  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
////
//
//import Foundation
//import AudioToolbox
//import AVFoundation
//import MediaPlayer
//
//class SoundManager : NSObject {
//    lazy var playerQueue : AVQueuePlayer = {
//        return AVQueuePlayer()
//    }()
//    static let sound : SoundManager = {
//        
//        let sound = SoundManager()
//        return sound
//    }()
//    var isPaly = false
//    override init() {
//        super.init()
//        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
//            MPMediaItemPropertyTitle: "القرآن الكريم",
//            
//        ]
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(SoundManager.timeJumped), name: NSNotification.Name.AVPlayerItemTimeJumped, object: nil)
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//        }catch {
//            print(error.localizedDescription)
//        }
//        UIApplication.shared.beginReceivingRemoteControlEvents()
//        let commandCenter = MPRemoteCommandCenter.shared()
//        commandCenter.pauseCommand.isEnabled = true
//        commandCenter.pauseCommand.addTarget(self, action:#selector(SoundManager.soundPause))
//        commandCenter.playCommand.isEnabled = true
//        commandCenter.playCommand.addTarget(self, action: #selector(SoundManager.soundPlay))
//        
//    }
//    
//    func removeNotificationC (){
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemTimeJumped, object: nil)
//    }
//    
//    func startWith(url:String) {
//        self.playerQueue.pause()
//        self.playerQueue.removeAllItems()
//        let playerItem = AVPlayerItem.init(url: URL(string: url)!)
//        self.playerQueue.insert(playerItem, after: nil)
//        soundPlay()
//    }
//    func startWith(ayah:Ayah){
//        self.playerQueue.pause()
//        self.playerQueue.removeAllItems()
//        let playerItem = AVPlayerItem.init(url: URL(string: ayah.audio!)!)
//        playerItem.name = " آيه رقم \(ayah.numberInSurah!) ".appending("من \(ayah.sowra!.name!)")
//        self.playerQueue.insert(playerItem, after: nil)
//        soundPlay()
//    }
//    @objc func timeJumped() {
//        OperationQueue.main.addOperation {
//            MainPlayer.loadPlayer().chaekSound()
//            MainPlayer.loadPlayer().titleTxt.text = self.playerQueue.currentItem?.name
//            APP_DELEGATE.window?.addSubview(MainPlayer.loadPlayer())
//            
//        }
//    }
//    
//    //  func playerTimeJumped() {
//    //
//    //    print(CMTimeGetSeconds((playerQueue.currentItem?.loadedTimeRanges[0].timeRangeValue.duration)!))
//    //    MPNowPlayingInfoCenter.default().nowPlayingInfo = [
//    //
//    //      MPMediaItemPropertyTitle: "القرآن الكريم",
//    //      MPMediaItemPropertyPlaybackDuration: playerQueue.currentItem!.asset.duration.seconds,
//    //      MPNowPlayingInfoPropertyElapsedPlaybackTime: 0
//    //    ]
//    //  }
//    //  func startQueueWith(items:Array<String>) {
//    //    self.playerQueue.removeAllItems()
//    //    for item in items {
//    //      if let url = URL(string: item) {
//    //        let playerItem = AVPlayerItem.init(url: url)
//    //        self.playerQueue.insert(playerItem, after: nil)
//    //      }
//    //    }
//    //    soundPlay()
//    ////    self.playerQueue.play()
//    //  }
//    func startQueueWith(ayahs:Array<Ayah>) {
//        self.playerQueue.removeAllItems()
//        for item in ayahs {
//            if let url = URL(string: item.audio!) {
//                let playerItem = AVPlayerItem.init(url: url)
//                playerItem.name = " آيه رقم \(item.numberInSurah!) ".appending("من \(item.sowra!.name!)")
//                self.playerQueue.insert(playerItem, after: nil)
//            }
//        }
//        soundPlay()
//    }
//    func startQueueWith(sowr:Array<Sowra>) {
//        self.playerQueue.removeAllItems()
//        for item in sowr {
//            if let url = URL(string: item.url!) {
//                let playerItem = AVPlayerItem.init(url: url)
//                playerItem.name = item.name!
//                self.playerQueue.insert(playerItem, after: nil)
//            }
//        }
//        soundPlay()
//    }
//    func startWith(sowra:Sowra){
//        self.playerQueue.pause()
//        self.playerQueue.removeAllItems()
//        let playerItem = AVPlayerItem.init(url: URL(string: sowra.url!)!)
//        playerItem.name = sowra.name!
//        self.playerQueue.insert(playerItem, after: nil)
//        soundPlay()
//    }
//    //  func startQueueWith(sowra:Array<Sowra>) {
//    //    self.playerQueue.removeAllItems()
//    //    for item in ayahs {
//    //      if let url = URL(string: item.audio) {
//    //        let playerItem = AVPlayerItem.init(url: url)
//    //        playerItem.name = " آيه رقم \(item.numberInSurah) ".appending("من \(item.sowra!.name)")
//    //        self.playerQueue.insert(playerItem, after: nil)
//    //      }
//    //    }
//    //    self.playerQueue.play()
//    //  }
//    
//    @objc func soundPause() {
//        self.playerQueue.pause()
//        isPaly = false
//    }
//    @objc func soundPlay() {
//        self.playerQueue.play()
//        isPaly = true
//    }
//    func isPlay() -> Bool{
//        return isPaly
//    }
//    
//}
//
//
