//
//  PlayerVideoVC.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 11/02/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit

class PlayerVideoVC: UIViewController {
    
    
    @IBOutlet weak var videoView: UIWebView!
    
    var videoUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        videoView.allowsInlineMediaPlayback = true
        let videoURL = "<iframe width=\"\(videoView.frame.width)\" height=\"\(videoView.frame.height)\" src=\"\(videoUrl)/?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>"
        
        
        videoView.loadHTMLString(videoURL, baseURL: nil)
        
       
    }
    
    

    

}


