//
//  Searchscreencell.swift
//  ShareCB
//
//  Created by PC on 15/04/19.
//  Copyright © 2019 VPN. All rights reserved.
//

import UIKit

class Searchscreencell: UITableViewCell {

@IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblsearchtext: UILabel!
    
    @IBOutlet weak var lblsharespacename: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
