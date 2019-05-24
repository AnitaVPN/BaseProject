//
//  extraSignInVC.swift
//  BaseProject
//
//  Created by PC on 15/04/19.
//  Copyright © 2019 VPN. All rights reserved.

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FacebookCore
//import FacebookCore
//import FacebookLogin
import GoogleSignIn
import SVProgressHUD

class extraSignInVC: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    
    
    @IBOutlet var btnForgotPassword: UIButton!
    var strErrMsg = String()
    @IBOutlet var vwGmail: GIDSignInButton!
    @IBOutlet weak var btnSignUpClickEvent: UIButton!
    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGmail: GIDSignInButton!
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
        setupview()
    }
    
    //FIXME: View Fixes
    func setupview()
    {
        txtLogin.placeholder = "txt_username".localized()
        txtPassword.placeholder = "txt_password".localized()
        btnLogin.titleLabel?.text = "btn_login".localized()
        btnFacebook.titleLabel?.text = "btn_facebook".localized()
        btnSignUpClickEvent.titleLabel?.text = "Dont_have_an_account".localized()
        btnForgotPassword.titleLabel?.text = "btn_forgotpassword".localized()
        
        txtLogin.placeholder = "txt_username".localized();
        txtPassword.placeholder  = "txt_password".localized()
        
        //        txtLogin.font = Constant.fon
        
        utils.addLeftViewToTextFeild(textFeild: txtLogin, image: #imageLiteral(resourceName: "icon_email"), strPlaceHolder: "", padding: 30)
        utils.addLeftViewToTextFeild(textFeild: txtPassword, image: #imageLiteral(resourceName: "icon_password"), strPlaceHolder: "", padding: 30)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Button click events
    
    
    func addValidation() -> Bool
    {
        if(!utils.isValidEmail(testStr: txtLogin.text!))
        {
            strErrMsg = "Please enter correct Email Address"
            return false
        }
        if(txtLogin.text == "")
        {
            strErrMsg = "Please enter  Email Address"
            return false
        }
        if(txtPassword.text == "")
        {
            strErrMsg = "Please enter Password"
            return false
        }
        if((txtPassword.text?.count)! < 6 )
        {
            strErrMsg = "Please enter password more then 6 character"
            return false
        }
        return true
    }
    
    @IBAction func btnLoginClickEvent(_ sender: Any) {
        
        if(addValidation())
        {
            DispatchQueue.main.async {
                self.API_SIGNIN(type: 0)
            }
        }
        else
        {
            utils.displayAlert(strMessage: strErrMsg as NSString, simple: false, vc: self)
        }
    }
    
    @IBAction func btnFacebookClickEvent(_ sender: Any) {
        
        Constant.appDelObject.isFacebookLogin = true;
        self.getFacebookUserInfo();
    }
    
    @IBAction func btnGmailClickEvent(_ sender: Any) {
    }
    
    
    
    
    @IBAction func btnSignUpClickEvent(_ sender: Any) {
        
        
        let vc = HomeVC.init(nibName: "HomeVC", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnForgotPasswordClickEvent(_ sender: Any) {
        
        let vc = ForgotPassword.init(nibName: "ForgotPassword", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:- API Calling
    
    func API_SIGNIN(type : Int)
    {
        SVProgressHUD.setStatus("Please wait ...")
        let dict = NSMutableDictionary()
        var api_url = String()
        
        if(type == 0)
        {
            
            print("Manual Signin")
            api_url = Constant.URL_SIGNIN
            dict.setValue(txtLogin.text, forKey: "email");
            dict.setValue(txtPassword.text, forKey: "password");
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
                    UserDefaults.standard.set(self.txtLogin.text, forKey: Constant.user_email)
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
    
    
    
}
