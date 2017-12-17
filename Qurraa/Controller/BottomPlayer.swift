//
//  BottomPlayer.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 22/02/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit

class BottomPlayer: UIView{

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var readerLbl: UILabel!
    @IBOutlet weak var rewayaLbl: UILabel!
    @IBOutlet weak var playPause: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit(){
        Bundle.main.loadNibNamed("BottomView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
    }
    
    @IBAction func playPauseBtm(_ sender: UIButton) {
        
    }
    
    @IBAction func moreBtn(_ sender: Any) {
        
        
    }
    
    
    
}
