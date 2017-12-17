////
////  MainPlayer.swift
////  Qurraa
////
////  Created by Ahmad Ahrbi on 04/03/1439 AH.
////  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
////
//
//import UIKit
//
//class MainPlayer: UIView {
//    IBOutlet weak var stopBtn: UIButton!
//    @IBOutlet weak var titleTxt: UILabel!
//    private static var mainPlayer:MainPlayer? = nil
//    static var isRun = false
//    /*
//     // Only override draw() if you perform custom drawing.
//     // An empty implementation adversely affects performance during animation.
//     override func draw(_ rect: CGRect) {
//     // Drawing code
//     }
//     */
//    
//    
//    @IBAction func removView(_ sender: UIButton) {
//        self.removeFromSuperview()
//        SoundManager.sound.soundPause()
//        SoundManager.sound.playerQueue.removeAllItems()
//        MainPlayer.mainPlayer = nil
//        
//    }
//    
//    static func loadPlayer()-> MainPlayer {
//        let with = UIScreen.main.bounds.width
//        let y = UIScreen.main.bounds.height - 50
//        if  mainPlayer == nil {
//            mainPlayer = Bundle.main.loadNibNamed("MainPlayer", owner: APP_DELEGATE.window, options: nil)?[0] as? MainPlayer
//            mainPlayer?.frame = CGRect(x: 0, y: y, width: with, height: 50)
//        }
//        return mainPlayer!
//    }
//    static func removePlayer(){
//        if mainPlayer != nil {
//            mainPlayer?.removeFromSuperview()
//        }
//    }
//    @IBAction func stopBtnAction(_ sender: UIButton) {
//        if SoundManager.sound.isPlay() {
//            SoundManager.sound.soundPause()
//            sender.setImage(UIImage(named: "play"), for: UIControlState.normal)
//        }else {
//            sender.setImage(UIImage(named: "pause"), for: UIControlState.normal)
//            SoundManager.sound.soundPlay()
//        }
//    }
//    func chaekSound() {
//        if SoundManager.sound.isPlay() {
//            stopBtn.setImage(UIImage(named: "pause"), for: UIControlState.normal)
//        }else {
//            stopBtn.setImage(UIImage(named: "play"), for: UIControlState.normal)
//            
//        }
//        
//    }
//}
//
