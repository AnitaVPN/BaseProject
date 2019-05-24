//
//  TabbarVC_1.swift
//  BaseProject
//
//  Created by VPN on 16/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit

class TabbarVC_1: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var btnnewsharespace: UIButton!
    
    @IBOutlet weak var tblsharespace: UITableView!
    
    var arrsharespace = ["Sharespace 1","Sharespace 2","Sharespace 3","Sharespace 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptblviewsharespace()
        btnnewsharespace.layer.cornerRadius = 10
        btnnewsharespace.layer.borderWidth = 1
        btnnewsharespace.layer.borderColor = UIColor.clear.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.topItem?.title = "Sharespace1"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255, green: 53/255, blue: 60/255, alpha: 1.0)
    }
    
    func setuptblviewsharespace(){
        tblsharespace.delegate = self
        tblsharespace.dataSource = self
        tblsharespace.register(UINib(nibName: "newsharespacecell", bundle: nil), forCellReuseIdentifier: "cellsharespace")
    }

    @IBAction func btnnewsharespaceTapped(_ sender: Any) {
        
    }
    
    //MARK:- tableviewdelegatemethods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrsharespace.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblsharespace.dequeueReusableCell(withIdentifier: "cellsharespace", for: indexPath) as! newsharespacecell
        cell.lblsharespace.text = arrsharespace[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your sharespace list"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let borderUp = UIView(frame: CGRect(x:0, y:10, width: tableView.bounds.size.width, height: 1.0))
        borderUp.backgroundColor = UIColor.self.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
        headerView.addSubview(borderUp)
        
        let borderBottom = UIView(frame: CGRect(x:0, y:55, width: tableView.bounds.size.width, height: 1.0))
        borderBottom.backgroundColor = UIColor.self.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
        headerView.addSubview(borderBottom)
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 28, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Your sharespace list", size: 12)
        headerLabel.textColor = UIColor.init(red: 101/255, green: 101/255, blue: 101/255, alpha: 1.0)
        headerLabel.text = self.tableView(self.tblsharespace, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
