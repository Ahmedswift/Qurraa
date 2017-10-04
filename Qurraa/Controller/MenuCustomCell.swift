//
//  MenuCustomCell.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 13/01/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit

class MenuCustomCell: UITableViewCell {
    
    @IBOutlet weak var menuImg: UIImageView!
    
    @IBOutlet weak var menuTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
