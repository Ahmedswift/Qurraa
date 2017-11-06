//
//  TVVC.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 09/02/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit

class TVVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var videoImage = ["Almaram","PMosque"]
    var videoTitle = ["Qur'ran TV Channel (Makkah)", "Sunnah TV Channel (Madinah)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().rearViewRevealWidth = 140
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        
        
       
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath) as! TVCell
        cell.channelName.text = videoTitle[indexPath.row]
        cell.channelImg.image = UIImage(named: videoImage[indexPath.row])
        cell.PlayerIcon.image = UIImage(named: "playerBtn")
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VideoPlayerSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! PlayerVideoVC
                if indexPath.row == 0 {
                    destinationController.videoUrl = "https://www.youtube.com/embed/erfCaD_DihM"
                } else if indexPath.row == 1 {
                    destinationController.videoUrl = "https://www.youtube.com/embed/ns6S1z_EIlE"
                }
                
            }
            
        }
    }
    

}








