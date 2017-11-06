//
//  RadioTVCell.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 14/02/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit

class RadioTVCell: UITableViewCell {
    
    @IBOutlet weak var radioname: UILabel!
    @IBOutlet weak var radioImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
