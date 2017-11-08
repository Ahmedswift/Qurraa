//
//  DownloadsTVC.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 17/02/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit

class DownloadsTVC: UITableViewCell {

    @IBOutlet weak var suraImage: UIImageView!
    
    @IBOutlet weak var suraName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setCell(sura: SurasMO) {
        suraName.text = sura.suraName
        
        
        
    }

    

}
