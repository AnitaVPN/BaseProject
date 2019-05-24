//
//  Notification.swift
//  ShareCB
//
//  Created by PC on 15/04/19.
//  Copyright © 2019 VPN. All rights reserved.
//

import UIKit

class Notification: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
     @IBOutlet weak var tblnotification: UITableView!
    
    let images = [UIImage(named: "man"),UIImage(named: "girl"),UIImage(named: "man"),UIImage(named: "girl"),UIImage(named: "man")]
    
    let notificationarr = ["Non karakaem shared with you non 2 ","Jiranan shared with you non 2","abc shared with you non 2"," shared with you non 2"," karakaem shared with you non 2"]
    
    let timearr = ["a day ago","2 days ago","1 day ago","3 days ago","2 days ago"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notification = UIBarButtonItem(title: "Notifications", style: .plain, target: self, action: #selector(Notification))
        let markasread = UIBarButtonItem(title: "Mark as read", style: .plain, target: self, action: #selector(Markasread))
        notification.tintColor = UIColor.white
        markasread.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = notification
        navigationItem.rightBarButtonItems = [markasread]
        setuptblviewnotification()
    }
    
    func setuptblviewnotification(){
        tblnotification.delegate = self
        tblnotification.dataSource = self
        tblnotification.register(UINib(nibName: "Notificationcell", bundle: nil), forCellReuseIdentifier: "cellnotification")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255, green: 53/255, blue: 60/255, alpha: 1.0)
    }

    @objc func Notification(){
        let alert = UIAlertController(title: "Sharecb", message: "save", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func Markasread(){
        let alert = UIAlertController(title: "Sharecb", message: "logout", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    //MARK:- tableview delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblnotification.dequeueReusableCell(withIdentifier: "cellnotification", for: indexPath) as! Notificationcell
        cell.lbltime.text = timearr[indexPath.row]
        cell.lblnotification.text = notificationarr[indexPath.row]
        cell.imgview.image = images[indexPath.row]
        
        cell.lblnotification.numberOfLines = 0
        cell.lblnotification.preferredMaxLayoutWidth = 700
        cell.lblnotification.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.lblnotification.sizeToFit()
        
        cell.imgview.layer.borderWidth = 1.0
        cell.imgview.layer.masksToBounds = false
        cell.imgview.layer.borderColor = UIColor.clear.cgColor
        cell.imgview.layer.cornerRadius = cell.imgview.frame.size.width / 2
        cell.imgview.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "You have 2 Unread Notifications"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
//        let borderBottom = UIView(frame: CGRect(x:0, y:58, width: tableView.bounds.size.width, height: 1.0))
//        borderBottom.backgroundColor = UIColor.self.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
//        headerView.addSubview(borderBottom)
        
        let headerLabel = UILabel(frame: CGRect(x: 12, y: 30, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "You have 2 Unread Notifications", size: 10)
        headerLabel.textColor = UIColor.black
        headerLabel.text = self.tableView(self.tblnotification, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        
        headerView.addSubview(headerLabel)
        return headerView
    }
}
