//
//  HomeVC.swift
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

class HomeVC: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    
    
    @IBOutlet weak var btnFacebook: UIButton!    
    @IBOutlet weak var vwGoogleGmail: GIDSignInButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    let api = ServerAPI()
    let utils = Utils()
    var modelClass = UserModelClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = Constant.GOOGLE_CLIENT_ID;
        GIDSignIn.sharedInstance().delegate = self
        
        vwGoogleGmail.layer.cornerRadius = 25;
        vwGoogleGmail.clipsToBounds = true;
        
        self.navigationController?.navigationBar.barTintColor = Constant.navigationBarColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
          self.navigationController?.navigationBar.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
//            dict.setValue(txtLogin.text, forKey: "email");
//            dict.setValue(txtPassword.text, forKey: "password");
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
//            dict.setValue(txtPassword.text, forKey: "Image");
            
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
                    
//                    UserDefaults.standard.set(self.txtPassword.text, forKey: Constant.user_current_password)
//                    UserDefaults.standard.set(self.txtLogin.text, forKey: Constant.user_email)
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            
            let modelClass = UserModelClass()
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
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
        
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
    
    
    @IBAction func btnFacebookClickEvent(_ sender: Any) {
        
        Constant.appDelObject.isFacebookLogin = true;
        self.getFacebookUserInfo();
    }
    
    
    
//    @IBAction func btnGoogleClickEvent(_ sender: Any) {
//        
//    }
    
    @IBAction func btnEmailclickEvent(_ sender: Any) {
        
        let vc = SignUpVC.init(nibName: "SignUpVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnLoginClickEvent(_ sender: Any) {
        
        let vc = SignInVC.init(nibName: "SignInVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}
