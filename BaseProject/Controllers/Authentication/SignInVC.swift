//
//  SignInVC.swift
//  BaseProject
//
//  Created by VPN on 16/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FacebookCore
//import FacebookCore
//import FacebookLogin
import GoogleSignIn
import SVProgressHUD

class SignInVC: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {

    
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var unCheckedImgView: UIImageView!
    @IBOutlet weak var CheckedImgView: UIImageView!
    @IBOutlet weak var btnRemeberCheck: UIButton!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    @IBOutlet weak var btnFacebookLogin: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var strErrMsg = String()
//    @IBOutlet var vwGmail: GIDSignInButton!
//
//    @IBOutlet weak var btnGmail: GIDSignInButton!
    let api = ServerAPI()
    let utils = Utils()
    var modelClass = UserModelClass()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = Constant.GOOGLE_CLIENT_ID;
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().signOut()

        
        btnLogin.layer.cornerRadius = 25;
        btnLogin.clipsToBounds = true;
 
       
       
        
        self.navigationController?.navigationBar.barTintColor = Constant.navigationBarColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
            unCheckedImgView.isHidden = false
            CheckedImgView.isHidden = true
        
            txtPassword.isSecureTextEntry = true
        
        setupview()
    }
    
    //FIXME: View Fixes
    func setupview()
    {
//        txtLogin.placeholder = "txt_username".localized()
//        txtPassword.placeholder = "txt_password".localized()
//        btnLogin.titleLabel?.text = "btn_login".localized()
//        btnFacebook.titleLabel?.text = "btn_facebook".localized()
//        btnSignUpClickEvent.titleLabel?.text = "Dont_have_an_account".localized()
//        btnForgotPassword.titleLabel?.text = "btn_forgotpassword".localized()
//
//        txtLogin.placeholder = "txt_username".localized();
//        txtPassword.placeholder  = "txt_password".localized()
        
//        txtLogin.font = Constant.fon
        
        utils.addLeftViewToTextFeild(textFeild: txtEmailAddress, image: #imageLiteral(resourceName: "email.png"), strPlaceHolder: "", padding: 30)
        utils.addLeftViewToTextFeild(textFeild: txtPassword, image: #imageLiteral(resourceName: "lockPassword.png"), strPlaceHolder: "", padding: 30)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Button click events
    
    func addValidation(isRegister:Bool) -> Bool
    {
        if(utils.isValidEmail(testStr: txtEmailAddress.text!) == false)
        {
            strErrMsg = "Please enter correct email address"
            print(strErrMsg)
            return false
        }
       
        if(txtEmailAddress.text == "")
        {
            strErrMsg = "Please enter  email address "
            return false
        }
        
        if(txtPassword.text == "")
        {
            strErrMsg = "Please enter password."
            return false
        }
        
        
        if((txtPassword.text?.count)! < 6)
        {
            strErrMsg = "Please enter password of minimum 6 character"
            return false
        }
        
        if(txtEmailAddress.text == "" && txtPassword.text == "")
        {
            strErrMsg = "Please enter required feild"
            return false
        }

        return true;
    }
    
    
    //MARK:- API Calling
    
    func apiCallForSignIn(isRegister:Bool)
    {
        SVProgressHUD.show(withStatus: "Please wait...")
        let dict = NSMutableDictionary()
        var url = String()
        if(!isRegister)
        {
            dict.setValue(txtEmailAddress.text, forKey: "email");
            dict.setValue(txtPassword.text, forKey: "password");
            dict.setValue("cDq8tAqyWv0:APA91bE6NshDHcZnX8m8bP9-TKOuj3T6H7X324QElcEB01rT_eDWYidpJjm7C3AaapFBXp5dp0WYTKSoATZlA0W4xT2oO460ZO8Xy8JudnVtmf6lMkxlHHGhaupZ0n8eTzFrog573bbs", forKey: "device_token");
            
            url = Constant.URL_SIGNIN
        }
        api.POST_API_CALL(str: url, isApplyToken: false, isAppliedBasicAuthentication: true, dict: dict, queryStr: "test", onSuccess: { (json) in
            DispatchQueue.main.async {
                let dictParse = json as? NSDictionary
                let dictM = NSMutableDictionary.init(dictionary: dictParse!)
                let isSuceed = dictParse?.value(forKey: "response") as! Bool
                let SuceesMsg = dictParse?.value(forKey: "message") as! String
                let errorMsg = dictParse?.value(forKey: "message") as? String
                
                if(isSuceed)
                {
                    SVProgressHUD.dismiss()
                    
                    let alertController = UIAlertController(title: Constant.appName, message: SuceesMsg , preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        
                        self.appDelegate.setupRootVCWithTab(isEnableSideMenu: false)
//                        let vc = HomeVC.init(nibName: "HomeVC", bundle: nil)
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true , completion: nil)
                    
                }
                    
                else
                {
                    SVProgressHUD.dismiss()
                    self.utils.displayAlert(strMessage: (errorMsg)! as String as NSString, simple: false, vc: self)
                    
                }
            }
        }) { (err) in
            DispatchQueue.main.async {
                // SVProgressHUD.dismiss()
                
                self.utils.displayAlert(strMessage: (err?.localizedDescription)! as String as NSString, simple: false, vc: self)
            }
        }
    }
    
    func API_SIGNIN(type : Int)
    {
        SVProgressHUD.setStatus("Please wait ...")
        let dict = NSMutableDictionary()
        var api_url = String()
        
        if(type == 0)
        {
            print("Manual Signin")
            
            if(addValidation(isRegister: false))
            {
                //            SVProgressHUD.show()
                apiCallForSignIn(isRegister: false)
                //            SVProgressHUD.dismiss()
            }
            else
            {
                utils.displayAlert(strMessage: strErrMsg as NSString, simple: true, vc: self)
            }
        }
        
        if(type == 1)
        {
            api_url = Constant.URL_SIGNUP_FACEBOOK
            print("FACEBOOK LOGIN")

            //Facebook
            dict.setValue(modelClass.user_id, forKey: "id");
            dict.setValue(modelClass.first_name, forKey: "first_name");
            dict.setValue(modelClass.last_name, forKey: "last_name");
            dict.setValue(modelClass.email_address, forKey: "email");
            dict.setValue(modelClass.user_name, forKey: "name");
        }
        
        if(type == 2)
        {
            api_url = Constant.URL_SIGNUP_GOOGLE
            print("GOOGLE LOGIN")
            //Google GMAIL
            dict.setValue(modelClass.user_id, forKey: "userID");
            dict.setValue(modelClass.first_name, forKey: "given_name");
            dict.setValue(modelClass.last_name, forKey: "family_name");
            dict.setValue(modelClass.email_address, forKey: "email");
            dict.setValue(modelClass.user_name, forKey: "profile name");
            dict.setValue(txtPassword.text, forKey: "Image");
            
        }
        
        
        
        api.POST_API_CALL(str: api_url, isApplyToken: true, isAppliedBasicAuthentication: true, dict: dict, queryStr: "test", onSuccess: { (json) in
            
            let dictParse = json as? NSDictionary
            let sucess = dictParse?.value(forKey: "response") as? Bool
            
            if(sucess)!
            {
                DispatchQueue.main.async {
                    let arr = dictParse?.value(forKey: "data") as? NSDictionary
                    print(arr?.count);
                    SVProgressHUD.dismiss()
                    
                    Constant.appDelObject.userModelClass = self.modelClass.initDict(dict: NSMutableDictionary.init(dictionary: arr!));
                    
                    UserDefaults.standard.set(self.txtPassword.text, forKey: Constant.user_current_password)
                    UserDefaults.standard.set(self.txtEmailAddress.text, forKey: Constant.user_email)
                    UserDefaults.standard.set(arr?.value(forKey: "id") as? String, forKey: Constant.user_id)
                    UserDefaults.standard.synchronize()
                    Constant.appDelObject.setupRootVCWithSideMenu()
                }
                
            }
            else
            {
                SVProgressHUD.dismiss()
                let errMsg = dictParse?.value(forKey: "message") as? String;
                let dictE = dictParse?.value(forKey: "errors") as? NSDictionary
                if(dictE != nil)
                {
                    let msg = dictE?.value(forKey: dictE?.allKeys[0] as! String) as? String
                    self.utils.displayAlert(strMessage: msg! as NSString, simple: false, vc: self)
                }
                else
                {
                    self.utils.displayAlert(strMessage: errMsg as! NSString, simple: false, vc: self)
                    GIDSignIn.sharedInstance().signOut()

                }
            }
            
            
            
        }) { (err) in
            
            SVProgressHUD.dismiss()
            self.utils.displayAlert(strMessage: (err?.localizedDescription)! as String as NSString, simple: false, vc: self)
        }
    }
    
    
//    func demoAPICall()
//    {
//        let dict = NSMutableDictionary()
//        dict.setValue("77", forKey: "customer_id")
//        dict.setValue("286,284", forKey: "selected_value")
//
//        api.POST_API_CALL(str: "http://clients.vpninfotech.com/narolagroups/api/v1/api_customer_product/export_order_api", isApplyToken: false, isAppliedBasicAuthentication: true, dict: dict, queryStr: "test", onSuccess: { (json) in
//            print(json)
//        }) { (err) in
//            print("error")
//        }
//
//    }
    
    //MARK:- Facebook
    func getFacebookUserInfo(){
        let loginManager = LoginManager()
        loginManager.logOut()
        let cookies = HTTPCookieStorage.shared
        let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie )
        }
        
        
        loginManager.logIn(readPermissions: [.publicProfile, .email ], viewController: self) { (result) in
            
            switch result{
            case .cancelled:
                print("Cancel button click")
            case .success:
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email"]
                let graphRequest = FBSDKGraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = FBSDKGraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    let info = result as! [String : AnyObject]
                    print(info["name"] as! String)
                    
                    self.modelClass.user_id = (info["id"] as! String);
                    self.modelClass.user_name = (info["name"] as! String)
                    self.modelClass.first_name = (info["first_name"] as! String)
                    self.modelClass.last_name = (info["last_name"] as! String)
                    self.modelClass.email_address = (info["email"] as! String)
                    
                    if(info["picture"] != nil)
                    {
                        let pictureDict = info["picture"] as? NSDictionary
                        let dictData = pictureDict?.value(forKey: "data") as? NSDictionary
                        let url = dictData?.value(forKey: "url") as? String
                        if(url != nil)
                        {
                            self.modelClass.profile_image = url!
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.API_SIGNIN(type: 1)
                    }
                    
                }
                Connection.start()
            default:
                print("??")
            }
        }
        
    }
    
    //MARK:- Google Methods
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            
            modelClass.user_id = user.userID;
            modelClass.acess_token = user.authentication.idToken
            modelClass.user_name = user.profile.name
            modelClass.first_name = user.profile.givenName
            modelClass.email_address = user.profile.email
            if(user.profile.hasImage)
            {
                let dimension = round(100)
                let pic = user.profile.imageURL(withDimension: UInt(dimension))
                modelClass.profile_image = (pic?.relativePath)!;
            }
            
            DispatchQueue.main.async {
                self.API_SIGNIN(type: 2)
            }
            
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
        Constant.appDelObject.isFacebookLogin = false;
        SVProgressHUD.dismiss()
        
    }
    
    // Present a view that prompts the user to sign in with Google
    internal func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnRememberMeClickEvent(_ sender: Any) {
        
        if(unCheckedImgView.isHidden == true)
        {
            unCheckedImgView.isHidden = false
            CheckedImgView.isHidden = true
           
        }
        
        else
        {
            unCheckedImgView.isHidden = true
            CheckedImgView.isHidden = false
        }
        
        
    }
    
    @IBAction func btnShowPasswordClickEvent(_ sender: Any) {
        
//         txtPassword.isSecureTextEntry = false
        
        if(txtPassword.isSecureTextEntry == true)
        {
           txtPassword.isSecureTextEntry = false
            
        }
            
        else
        {
           txtPassword.isSecureTextEntry = true
        }
    }
    
    
    @IBAction func btnFacebookLoginClickEvent(_ sender: Any) {
        
        Constant.appDelObject.isFacebookLogin = true;
        self.getFacebookUserInfo();
    }
    
    //Google login
    
    
    
    @IBAction func btnLoginClickEvent(_ sender: Any) {
        
        if(addValidation(isRegister: false))
        {
            apiCallForSignIn(isRegister: false)
           
        }
        else
        {
            utils.displayAlert(strMessage: strErrMsg as NSString, simple: true, vc: self)
        }
        
    }
    
    func addValidation() -> Bool
    {
        if(txtEmailAddress.text == "")
        {
            strErrMsg = "Please enter required feild"
            return false
        }
        if(utils.isValidEmail(testStr: txtEmailAddress.text!) == false)
        {
            strErrMsg = "Please enter correct email address"
            print(strErrMsg)
            return false
        }
        return true;
    }
    
    func apiCallForForgotPassword(isRegister:Bool)
    {
        SVProgressHUD.show()
        let dict = NSMutableDictionary()
        var url = String()
  
        dict.setValue(txtEmailAddress.text, forKey: "email");
        
        url = Constant.URL_FORGOT_PASSWORD
        
        api.POST_API_CALL(str: url, isApplyToken: false, isAppliedBasicAuthentication: true, dict: dict, queryStr: "test", onSuccess: { (json) in
            DispatchQueue.main.async {
                
                let dictParse = json as? NSDictionary
                let dictM = NSMutableDictionary.init(dictionary: dictParse!)
                let issuccess = dictParse?.value(forKey: "response") as! Bool
                let SuccessMsg = dictParse?.value(forKey: "success") as? String
                let error = dictParse?.value(forKey: "errors") as? NSDictionary
//                let errorEmail = error?.value(forKey: "email") as? String //when email field is empty
                let errorEmail = dictParse?.value(forKey: "message") as? String
                
                if(issuccess)
                {
                    SVProgressHUD.dismiss()
                 
                    let alertController = UIAlertController(title: "Success!", message: SuccessMsg!, preferredStyle: .alert)
                    let SuccessAction = UIAlertAction(title: "BACK TO LOGIN", style: .default)
                    
                    SuccessAction.setValue(Constant.alertButtonColor, forKey: "titleTextColor")
                    alertController.addAction(SuccessAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else
                {
//                    self.utils.displayAlert(strMessage:errorEmail! as NSString, simple: false, vc: self)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//                        self.navigationController?.popViewController(animated: true)
//                    })
                    SVProgressHUD.dismiss()
                    self.utils.displayAlert(strMessage: errorEmail! as NSString, simple: false, vc: self)
                }
            }
            
        }) { (err) in
            DispatchQueue.main.async {
                
                self.utils.displayAlert(strMessage: "Email has been sent to your email address for reset password", simple: false, vc: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    self.navigationController?.popViewController(animated: true)
                    
                })
                //                self.util.displayAlert(strMessage: (err?.localizedDescription)! as String as NSString, simple: false, vc: self)
            }
        }
    }
    
    func showAlertWithTextField() {

        let alertController = UIAlertController(title: "Reset Password", message: "Enter email address associated with your account , and we will email you a link to reset your password", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "SEND", style: .default) { (confirmAction) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                // operations
                self.txtEmailAddress = txtField
                print("Text==>" + text)

                if(self.addValidation())
                {
                    self.apiCallForForgotPassword(isRegister: false)
                }
                else
                {
                    self.utils.displayAlert(strMessage: self.strErrMsg as NSString, simple: true, vc: self)
                }

            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Email Address"
        }

        confirmAction.setValue(Constant.alertButtonColor, forKey: "titleTextColor")
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
  
    
    @IBAction func btnforgotPassswordClickEvent(_ sender: Any) {
        
        showAlertWithTextField()
    }
    
    
    @IBAction func btnSignUpClickEvent(_ sender: Any) {
        let vc = HomeVC.init(nibName: "HomeVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
