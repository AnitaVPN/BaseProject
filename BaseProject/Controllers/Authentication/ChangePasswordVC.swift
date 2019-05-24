//
//  ChangePasswordVC.swift
//  BaseProject
//
//  Created by VPN on 16/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordVC: UIViewController {

    
    var errorMsg = String()
    var currentPassword = String()
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtCPassword: UITextField!
    @IBOutlet weak var btnChangePasswordClickEvents: UIButton!
    let utils = Utils()

    @IBOutlet weak var btnChangePassword: UIButton!
    
    let api = ServerAPI()
    
    //MARK:- Class methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        utils.addLeftViewToTextFeild(textFeild: txtCurrentPassword, image:#imageLiteral(resourceName: "icon_password") , strPlaceHolder: "", padding: 30)
        utils.addLeftViewToTextFeild(textFeild: txtNewPassword, image:#imageLiteral(resourceName: "icon_password") , strPlaceHolder: "", padding: 30)
        utils.addLeftViewToTextFeild(textFeild: txtCPassword, image:#imageLiteral(resourceName: "icon_password") , strPlaceHolder: "", padding: 30)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnChangePassword(_ sender: Any) {
        if(addValidation())
        {
            self.API_CHANGE_PASSWORD()
        }
        else
        {
            utils.displayAlert(strMessage: errorMsg as NSString, simple: false, vc: self)
        }
    }
    
    
    func addValidation() -> Bool
    {
        currentPassword = UserDefaults.standard.value(forKey: Constant.user_current_password) as! String
        
        if(txtCurrentPassword.text == "")
        {
             errorMsg = "Please enter current password."
             return false
        }
        
        if(txtNewPassword.text == "")
        {
             errorMsg = "Please enter new password."
             return false
        }
        
        if(txtCPassword.text == "")
        {
             errorMsg = "Please enter confirm password."
             return false
        }
        
        if(currentPassword != txtCurrentPassword.text)
        {
             errorMsg = "Old Password not matched."
             return false
        }
        
        if(txtNewPassword.text != txtCPassword.text)
        {
            errorMsg = "New password and confirm password are not identical."
            return false
        }
        
        return true
        
    }
    
    
    //MARK:- Button click events
    
    //MARK:- API Calling
    
    func API_CHANGE_PASSWORD()
    {
        SVProgressHUD.setStatus("Please wait ...")
        let dict = NSMutableDictionary()
        dict.setValue(txtCurrentPassword.text, forKey: "old_password");
        dict.setValue(txtNewPassword.text, forKey: "new_password");
        dict.setValue(txtCPassword.text, forKey: "confirm_password");
        dict.setValue(UserDefaults.standard.value(forKey: Constant.user_id) as! String, forKey: "id");

        api.POST_API_CALL(str: Constant.URL_CHANGE_PASSWORD, isApplyToken: true, isAppliedBasicAuthentication: true, dict: dict, queryStr: "test", onSuccess: { (json) in
            
            let dictParse = json as? NSDictionary
            let sucess = dictParse?.value(forKey: "response") as? Bool
            
            if(sucess)!
            {
                DispatchQueue.main.async {
                    let arr = dictParse?.value(forKey: "data") as? NSArray
                    print(arr?.count);
                    SVProgressHUD.dismiss()
                    self.utils.displayAlert(strMessage: dictParse?.value(forKey: "message") as! String as NSString, simple: false, vc: self)
                    self.navigationController?.popViewController(animated: true)
                    UserDefaults.standard.set(self.txtNewPassword.text, forKey: Constant.user_current_password)
                    UserDefaults.standard.synchronize()
                }
                
            }
            else
            {
                SVProgressHUD.dismiss()
                let errMsg = dictParse?.value(forKey: "message") as? String;
                self.utils.displayAlert(strMessage: errMsg! as NSString, simple: false, vc: self)
            }

            
        }) { (err) in
            
            SVProgressHUD.dismiss()
            self.utils.displayAlert(strMessage: (err?.localizedDescription)! as String as NSString, simple: false, vc: self)
        }
    }

}
