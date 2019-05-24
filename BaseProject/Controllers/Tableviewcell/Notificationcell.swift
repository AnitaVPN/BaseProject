//
//  Notificationcell.swift
//  ShareCB
//
//  Created by PC on 15/04/19.
//  Copyright © 2019 VPN. All rights reserved.
//

import UIKit

class Notificationcell: UITableViewCell {

    @IBOutlet weak var imgview: UIImageView!
    
    @IBOutlet weak var lblnotification: UILabel!
    
    @IBOutlet weak var lbltime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
