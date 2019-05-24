//
//  ForgotPassword.swift
//  BaseProject
//
//  Created by VPN on 16/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController {

    
    @IBOutlet weak var btnEmailAddress: UITextField!
    @IBOutlet weak var btnChangePassword: UIButton!
    let util = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnEmailAddress.placeholder = "Please enter email address"
        util.addLeftViewToTextFeild(textFeild: btnEmailAddress, image: #imageLiteral(resourceName: "icon_password"), strPlaceHolder: "", padding: 30)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- Button Click Events
    @IBAction func btnRecoverAccountClickEvent(_ sender: Any) {
        
        if(util.isValidEmail(testStr: btnEmailAddress.text!))
        {
            self.API_FORGOT_PASSWORD();
        }
        else
        {
            util.displayAlert(strMessage: "Please enter proper email address", simple: false, vc: self)
        }
        
    }
    
    func API_FORGOT_PASSWORD()
    {
        let api = ServerAPI()
        let dict = NSMutableDictionary()
        dict.setValue(btnEmailAddress.text, forKey: "email")
        api.POST_API_CALL(str: Constant.URL_FORGOT_PASSWORD, isApplyToken: false, isAppliedBasicAuthentication: true, dict: dict, queryStr: "test", onSuccess: { (json) in
            
            let dictParse = json as? NSDictionary
            let sucess = dictParse?.value(forKey: "response") as? Bool
            if(sucess)!
            {
                let msg = dictParse?.value(forKey: "success") as? String
                self.util.displayAlert(strMessage: msg as! NSString, simple: false, vc: self)
            }
            else
            {
                let msg = dictParse?.value(forKey: "message") as? String
                self.util.displayAlert(strMessage: msg as! NSString, simple: false, vc: self)
            }
        }) { (err) in
            
        }
    }
    
}
