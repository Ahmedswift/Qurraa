//
//  TVCell.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 10/02/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit

class TVCell: UITableViewCell {
    
    @IBOutlet weak var channelName: UILabel!
    
    @IBOutlet weak var channelImg: UIImageView!
    
    @IBOutlet weak var PlayerIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
