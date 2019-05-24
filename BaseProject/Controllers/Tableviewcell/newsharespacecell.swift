//
//  newsharespacecell.swift
//  ShareCB
//
//  Created by PC on 15/04/19.
//  Copyright © 2019 VPN. All rights reserved.
//

import UIKit

class newsharespacecell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblsharespace: UILabel!
    
    @IBOutlet weak var view1: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyShadowToView(view: view1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func applyShadowToView(view : UIView)
    {
        view1.layer.shadowColor = UIColor.black.cgColor
        view1.layer.shadowOpacity = 5
        view1.layer.shadowOffset = CGSize.zero
        view1.layer.shadowRadius = 10
        view1.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view1.layer.shouldRasterize = true
    }
    
}
