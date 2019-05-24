//
//  TabbarVC_3.swift
//  BaseProject
//
//  Created by VPN on 16/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit

class TabbarVC_3: UIViewController {
    
     var navBar: UINavigationBar = UINavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image = UIImage(named: "girl")
        image = image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: nil, action: #selector(anotherMethod))
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "menu-1"), for: .normal)
        //button.frame = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
        button.addTarget(self, action: #selector(anotherMethod), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [barButtonItem]
        
         self.setNavBarToTheView()
        }

        func setNavBarToTheView() {
        self.navBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)  // Here you can set you Width and Height for your navBar
        self.view.addSubview(navBar)
    }
    
    @objc func anotherMethod(){
        let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255, green: 53/255, blue: 60/255, alpha: 1.0)
        
        navigationController?.navigationBar.topItem?.title = "Sharespace1"

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let attributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 30)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)

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
