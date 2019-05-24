//
//  TabbarVC_2.swift
//  BaseProject
//
//  Created by VPN on 16/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit

class TabbarVC_2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var tblsearch: UITableView!
    
    var Searchresult = ["Final approve cost","Grand opening event","Non karakarn shared a link","Final approve price V2"]
    
    var sharespace = ["sharespace1","sharespace1","sharespace1","sharespace1"]
    
    var images = [UIImage(named: "dc"),UIImage(named: "download"),UIImage(named: "dc"),UIImage(named: "download")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setuptblviewsearch()
        
//        imgviewprofile.layer.borderWidth = 1.0
//        imgviewprofile.layer.masksToBounds = false
//        imgviewprofile.layer.borderColor = UIColor.clear.cgColor
//        imgviewprofile.layer.cornerRadius = imgviewprofile.frame.size.width / 2
//        imgviewprofile.clipsToBounds = true
    }

    //MARK :-  Method for setup tblviewsearch
    func setuptblviewsearch(){
        tblsearch.delegate = self
        tblsearch.dataSource = self
        tblsearch.register(UINib(nibName: "Searchscreencell", bundle: nil), forCellReuseIdentifier: "cellsearch")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.topItem?.title = "Search"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255, green: 53/255, blue: 60/255, alpha: 1.0)
    }
    
    
    //MARK:- tblSearch Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Searchresult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblsearch.dequeueReusableCell(withIdentifier: "cellsearch", for: indexPath) as! Searchscreencell
        cell.lblsearchtext.text = Searchresult[indexPath.row]
        cell.lblsharespacename.text = sharespace[indexPath.row]
        cell.imgView.image = images[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent items"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let borderBottom = UIView(frame: CGRect(x:0, y:55, width: tableView.bounds.size.width, height: 1.0))
        borderBottom.backgroundColor = UIColor.self.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
        headerView.addSubview(borderBottom)
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 30, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Recent items", size: 13)
        headerLabel.textColor = UIColor.init(red: 101/255, green: 101/255, blue: 101/255, alpha: 1.0)
        headerLabel.text = self.tableView(self.tblsearch, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
}
