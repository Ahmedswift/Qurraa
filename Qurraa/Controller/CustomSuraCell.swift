//
//  SuraTableViewCell.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 14/01/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit

class CustomSuraCell: UITableViewCell {
    
    @IBOutlet weak var suraName: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
