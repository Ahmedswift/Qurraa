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
import CoreData
import Alamofire

class SurasPlayerVC: UIViewController, UIGestureRecognizerDelegate, ChangeSuraDelegate, ProgressViewDelegate{
    
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
    
    @IBOutlet weak var downloadPro: UIButton!
    
    @IBOutlet weak var randomSuraPop: UIButton!
    
    @IBOutlet weak var repeatPrp: UIButton!
    
    @IBOutlet weak var progressView: ProgressView!
    
    //
    var player : AVPlayer!
    var audioPlayer: AVAudioPlayer!
    var playerItem:AVPlayerItem!
    var selectedSuraUrl: String?
    var timeObserverToken: Any?
    
    var completedURL: String = ""
    var suraID: String = ""
    var reciterNameS: String = ""
    var rewaya: String = ""
    var currentSuras = [Sura]()
    var index = 0
    var flag = 0
    var flag1 = 0
    var suraCD: SurasMO?
    var suraaProgress: CGFloat?
    var suraa: Data?
    var suraDownloaded: Data?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true
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
        /**
         Set the animation style for progressView and font of the text
         **/
        progressView.animationStyle = kCAMediaTimingFunctionLinear
        progressView.font = UIFont.systemFont(ofSize: 17)
        
        progressView.delegate = self
        progressView.isUserInteractionEnabled  = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.startTheProgress(gesture:)))
        self.progressView.addGestureRecognizer(tapgesture)
        // Do any additional setup after loading the view, typically from a nib
        
 DispatchQueue.main.async {
    self.rewayaType.text = self.rewaya
    if self.selectedSuraUrl != nil {
    self.parseURLToPlayer(url: self.selectedSuraUrl, suraID: self.suraID)
    } else {
        self.playSura()
    }

        }
        
    }
    
    @objc func startTheProgress(gesture:UITapGestureRecognizer)
    {
        downloadUrl()
        self.progressView.animationStyle = kCAMediaTimingFunctionLinear
    }
    
    func playSura() {
        //let url = Bundle.main.url(forResource: "sura", withExtension: ".mp3")!
        do {
        //let data Data = try Data
           try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(data: suraDownloaded!, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer.prepareToPlay()
            //audioPlayer.play()
            playPauseAudio()
            //playerItem = AVPlayerItem(Data
            
            
        } catch {
            print("Error!")
        }
    }
    
    
    func finishedProgress(forCircle circle: ProgressView) {
        if circle == progressView{
            print("completed progress")
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
            //player.removeTimeObserver(timeObserverToken!)
            //NotificationCenter.default.removeObserver(self)
            
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
//            player.removeTimeObserver(timeObserverToken!)
//            NotificationCenter.default.removeObserver(self)
            
        }
        self.prevesSura()
        //self.restartUI()
    }
    
    
    @IBAction func btnGoToFirstVCTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindSegueTo1", sender: nil)
       
    }
    
    
    @IBAction func randomSura(_ sender: UIButton) {
        if flag == 0 {
            randomSuraPop.setImage(UIImage(named:"random"), for: .normal)
            flag = 1
        } else if flag == 1 {
            randomSuraPop.setImage(UIImage(named:"random_unclected"), for: .normal)
            flag = 0
        }
        
        
    }
    
    
    
    @IBAction func repeatBtn(_ sender: UIButton) {
        if flag1 == 0 {
            repeatPrp.setImage(UIImage(named:"repeat"), for: .normal)
            flag1 = 1
        } else if flag1 == 1 {
            repeatPrp.setImage(UIImage(named:"repeatUnselected"), for: .normal)
            flag1 = 0
        }
    }
    
    
    @IBAction func downloadBtn(_ sender: UIButton) {
        downloadPro.isHidden = true
        progressView.isHidden = false
        downloadUrl()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if playerItem != nil {
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if player != nil {
        NotificationCenter.default.removeObserver(self)
        player.removeTimeObserver(timeObserverToken!)
        }
    }
    
    
    
    
    func playPauseAudio() {
        if player != nil {
        if player?.rate == 0 {
        player.play()
        player.volume = 1.0
            playAPause.setImage(UIImage(named:"pause"), for: .normal)
            
        
        } else if player.rate != 0 {
            player.pause()
            playAPause.setImage(UIImage(named:"play"), for: .normal)
            player.rate = 0
            
        }
        }else {
            if audioPlayer.isPlaying {
                
                audioPlayer.pause()
                playAPause.setImage(UIImage(named:"play"), for: .normal)
                
                
            }else
            {
               
                audioPlayer.play()
                playAPause.setImage(UIImage(named:"pause"), for: .normal)
                
            }
        }
        
    }
   
    
    func parseURLToPlayer(url: String?, suraID: String) {
        
        DispatchQueue.main.async {
            
           if Int(suraID)! < 10 {
            self.completedURL = "\(url!)/00\(suraID).mp3"
           } else if Int(suraID)! >= 10 && Int(suraID)! < 100 {
            self.completedURL = "\(url!)/0\(suraID).mp3"
           } else {
            self.completedURL = "\(url!)/\(suraID).mp3"
            }
            if let url = URL(string: self.completedURL) {
                self.playerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: self.playerItem)
                self.playPauseAudio()
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
        
            timeObserverToken =   player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            
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
             let duration = self.playerItem.asset.duration
                let durationSeconds = CMTimeGetSeconds(duration)
            
                self.sliderItem.value = Float(seconds / durationSeconds)
            
            
        })
        
    }
    
//    func save() {
//
//        let myNewSuras = SurasMO(context: context)
//
//
////        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
////            suraCD = SurasMO(context: appDelegate.persistentContainer.viewContext)
////            suraCD?.sura = suraa
////            print(suraCD?.sura)
////            if let suraFile = suraCD?.sura {
////                print("the file dowloade, tha size is \(suraFile) ")
////
////            }
////        }
//    }
    
    func downloadUrl() {
        if let suraUrl = URL(string: completedURL){
            
            Alamofire.request(suraUrl).downloadProgress(closure: { (progress) in
            
                print(progress.fractionCompleted * 100)
                self.suraaProgress = CGFloat(progress.fractionCompleted * 100)
     self.progressView.setProgress(value: self.suraaProgress! , animationDuration: 5, completion: nil)
                
                
            }).responseData(completionHandler: { (response) in
                
                print(response.result)
                print(response.result.value)
                //self.suraa = response.result.value
                //self.save()
                 let myNewSuras = SurasMO(context: context)
                myNewSuras.suraName = self.suraTitle.text
                myNewSuras.reciter = self.reciterName.text
                myNewSuras.rewaya = self.rewaya
                myNewSuras.sura = response.result.value
                
                do {
                ad.saveContext()
                    print("Saved , Done!")
                    self.progressView.isHidden = true
                } catch {
                    print("Error")
                }
            })
            
            
//            // then lets create your document folder url
//            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//            // lets create your destination file url
//            let destinationUrl = documentsDirectoryURL.appendingPathComponent(suraUrl.lastPathComponent)
//
//            // to check if it exists before downloading it
//            if FileManager.default.fileExists(atPath: destinationUrl.path){
//                print("The file already exists at path")
//
//                // if the file doesn't exist
//            }else{
//                // you can use NSURLSession.sharedSession to download the data asynchronously
//                URLSession.shared.downloadTask(with: suraUrl, completionHandler: { (location, response, error) in
//                    guard let location = location, error == nil else { return }
//
//                    do {
//                        // after downloading your file you need to move it to your destination url
//                        try FileManager.default.moveItem(at: location, to: destinationUrl)
//                         print("File moved to documents folder")
//                    } catch let error as NSError {
//                        print(error.localizedDescription)
//                    }
//                }).resume()
//            }
        }
    }
    
    
    func nextSura() {
        if flag == 1 {
            index = Int(arc4random())%currentSuras.count
            
        }else if index < currentSuras.count - 1 {
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
        
        if flag1 == 1 {
           self.parseURLToPlayer(url: self.selectedSuraUrl, suraID: self.suraID)
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomSuras" {
            
            let destinationController = segue.destination as! SurasVC
            
            destinationController.currentSura = currentSuras
            destinationController.reciterName = reciterNameS
            destinationController.rewaya = rewaya
            destinationController.delegate = self
            destinationController.suraName = suraTitle.text!
            
        }
    }
    
    func userSelectedNewSuraName(sura: String) {
        self.parseURLToPlayer(url: self.selectedSuraUrl, suraID: sura)
    }
    
    
    
}






