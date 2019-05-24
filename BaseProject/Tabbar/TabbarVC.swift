//
//  TabbarVC.swift
//  BaseProject
//
//  Created by VPN on 16/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = tabBar.frame
        tabFrame.size.height = 70
        tabFrame.origin.y = self.view.frame.size.height - 70
        tabBar.frame = tabFrame
//        tabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -5, 0)
        
        
        
        self.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let button1 = UIBarButtonItem(image: UIImage(named: "menu-1"), style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem  = button1
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
