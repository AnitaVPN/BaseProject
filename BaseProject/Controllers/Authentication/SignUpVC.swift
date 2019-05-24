//
//  SignUpVC.swift
//  BaseProject
//
//  Created by VPN on 16/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleSignIn
import FacebookLogin
import FBSDKLoginKit
import FacebookCore


class SignUpVC: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate , GIDSignInUIDelegate,GIDSignInDelegate
{
  
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUP: UIButton!
    @IBOutlet weak var btnTermsConditions: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    let util = Utils()
    var strErrMsg = String()
    var imagePicker = UIImagePickerController()
    let api = ServerAPI()
    var modelClass = UserModelClass()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.navigationController?.navigationBar.isHidden = false
        
        setupTextFeild()
    }
    
    func setupTextFeild()
    {
        util.addLeftViewToTextFeild(textFeild: txtEmailAddress, image: #imageLiteral(resourceName: "email.png"), strPlaceHolder: "", padding: 20)
        util.addLeftViewToTextFeild(textFeild: txtFname, image: #imageLiteral(resourceName: "user-regular"), strPlaceHolder: "", padding: 20)
        util.addLeftViewToTextFeild(textFeild: txtLname, image: #imageLiteral(resourceName: "user-regular"), strPlaceHolder: "", padding: 20)
        util.addLeftViewToTextFeild(textFeild: txtPassword, image: #imageLiteral(resourceName: "lockPassword.png"), strPlaceHolder: "", padding: 20)
        
        imagePicker.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = Constant.GOOGLE_CLIENT_ID;
        GIDSignIn.sharedInstance().delegate = self
        
        
    }
    
//    func addValidation() -> Bool
//    {
//
//        if(txtEmailAddress.text == "")
//        {
//            strErrMsg = "Please enter  Email Address"
//            return false
//        }
//        if(txtPassword.text == "")
//        {
//            strErrMsg = "Please enter Password"
//            return false
//        }
//
//        if(txtFname.text == "")
//        {
//            strErrMsg = "Please enter First name "
//            return false
//        }
//        if(txtLname.text == "")
//        {
//            strErrMsg = "Please enter Last name "
//            return false
//        }
//        if(!util.isValidEmail(testStr: txtEmailAddress.text!))
//        {
//            strErrMsg = "Please enter correct Email Address"
//            return false
//        }
//        if((txtPassword.text?.count)! < 6 )
//        {
//            strErrMsg = "Please enter password more then 6 character"
//            return false
//        }
//
//        return true
//    }
    
    func addValidation(isRegister:Bool) -> Bool
    {
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
        if(txtEmailAddress.text == "" && txtPassword.text == "")
        {
            strErrMsg = "Please enter required feild"
            return false
        }
        
        if(txtFname.text == "")
        {
            strErrMsg = "Please enter First name "
            return false
        }
        
        if(txtLname.text == "")
        {
            strErrMsg = "Please enter Last name "
            return false
        }
        
        if(util.isValidEmail(testStr: txtEmailAddress.text!) == false)
        {
            strErrMsg = "Please enter correct email address"
            print(strErrMsg)
            return false
        }
        
        if((txtPassword.text?.count)! < 6)
        {
            strErrMsg = "Please enter password of minimum 6 character"
            return false
        }
        
        return true;
    }
    
    
    
    //MARK:- Facebook
    func getFacebookUserInfo(){
        let loginManager = LoginManager()
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
                        self.API_SIGNUP(type: 1)
                    }
                }
                Connection.start()
            default:
                print("??")
            }
        }
        
    }
    
    func apiCallForSignUP(isRegister:Bool)
    {
        SVProgressHUD.show(withStatus: "Please wait...")
        let dict = NSMutableDictionary()
        var url = String()
        if(!isRegister)
        {
            dict.setValue(txtEmailAddress.text, forKey: "email");
            dict.setValue(txtFname.text, forKey: "firstname");
            dict.setValue(txtLname.text, forKey: "lastname");
            dict.setValue(txtPassword.text, forKey: "password");
//            dict.setValue("2", forKey: "user_website_access");
            
            url = Constant.URL_SIGNUP
        }
        api.POST_API_CALL(str: url, isApplyToken: false, isAppliedBasicAuthentication: true, dict: dict, queryStr: "test", onSuccess: { (json) in
            DispatchQueue.main.async {
                let dictParse = json as? NSDictionary
                let dictM = NSMutableDictionary.init(dictionary: dictParse!)
                let isSuceed = dictParse?.value(forKey: "response") as! Bool
                let SuceesMsg = dictParse?.value(forKey: "message") as! String
                let error = dictParse?.value(forKey: "errors") as? NSDictionary
                let errorEmail = error?.value(forKey: "email") as? String
                
                if(isSuceed)
                {
                    SVProgressHUD.dismiss()
                    
//                    self.util.displayAlert(strMessage: SuceesMsg as String as NSString, simple: false, vc: self)
                    
//                    self.txtEmailAddress.text = self.txtEmailAddress.text
//                    self.txtFname.text = self.txtFname.text
//                    self.txtLname.text =  self.txtLname.text
//                    self.txtPassword.text = self.txtPassword.text
                    
                    let alertController = UIAlertController(title: Constant.appName, message: SuceesMsg , preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        
                       // self.appDelegate.setupRootVCWithTab(isEnableSideMenu: true)
                        
                        let vc = SignInVC.init(nibName: "SignInVC", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            
                else
                {
                    SVProgressHUD.dismiss()
                    self.util.displayAlert(strMessage: (errorEmail)! as String as NSString, simple: false, vc: self)
                    
                }
            }
        }) { (err) in
            DispatchQueue.main.async {
                // SVProgressHUD.dismiss()
                
                self.util.displayAlert(strMessage: (err?.localizedDescription)! as String as NSString, simple: false, vc: self)
            }
        }
    }
    
    
    func API_SIGNUP(type : Int)
    {
        SVProgressHUD.setStatus("Please wait ...")
        let dict = NSMutableDictionary()
        var api_url = String()
        
        if(type == 0)
        {
            if(addValidation(isRegister: false))
            {
                //            SVProgressHUD.show()
                apiCallForSignUP(isRegister: false)
                //            SVProgressHUD.dismiss()
            }
            else
            {
                util.displayAlert(strMessage: strErrMsg as NSString, simple: true, vc: self)
            }
            
        }
        
        if(type == 1)
        {
            api_url = Constant.URL_SIGNUP_FACEBOOK
            
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
            
            //Google GMAIL
            dict.setValue(modelClass.user_id, forKey: "userID");
            dict.setValue(modelClass.first_name, forKey: "givenName");
            dict.setValue(modelClass.last_name, forKey: "familyName");
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
                    SVProgressHUD.dismiss()
                    
                    UserDefaults.standard.setValue(type, forKey: "LoginT");
                    UserDefaults.standard.synchronize()
                    
                    let errMsg = dictParse?.value(forKey: "message") as? String;
                    self.util.displayAlert(strMessage: errMsg! as NSString, simple: false, vc: self)
                    self.navigationController?.popViewController(animated: true)
                    //Constant.appDelObject.setupRootVCWithSideMenu()
                }
                
            }
            else
            {
                SVProgressHUD.dismiss()
                let errMsg = dictParse?.value(forKey: "message") as? String;
                let dictE = dictParse?.value(forKey: "errors") as? NSDictionary
                if((dictE?.count)! > 0)
                {
                    let msg = dictE?.value(forKey: dictE?.allKeys[0] as! String) as? String
                    self.util.displayAlert(strMessage: msg! as NSString, simple: false, vc: self)
                }
            }
            
            
            
        }) { (err) in
            
            SVProgressHUD.dismiss()
            self.util.displayAlert(strMessage: (err?.localizedDescription)! as String as NSString, simple: false, vc: self)
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            
            modelClass.user_id = user.userID;
            modelClass.acess_token = user.authentication.idToken
            modelClass.user_name = user.profile.name
            modelClass.first_name = user.profile.givenName
            modelClass.last_name = user.profile.familyName
            modelClass.email_address = user.profile.email
            if(user.profile.hasImage)
            {
                let dimension = round(100)
                let pic = user.profile.imageURL(withDimension: UInt(dimension))
                modelClass.profile_image = (pic?.relativePath)!;
            }
            
            DispatchQueue.main.async {
                self.API_SIGNUP(type: 2)
            }
        }
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
    
    
    @IBAction func btnGoogleClickEvent(_ sender: Any) {
    }
    
    
    @IBAction func btnSignUpClickEvent(_ sender: Any) {
        
        if(addValidation(isRegister: false))
        {
            //            SVProgressHUD.show()
            apiCallForSignUP(isRegister: false)
            //            SVProgressHUD.dismiss()
        }
        else
        {
            util.displayAlert(strMessage: strErrMsg as NSString, simple: true, vc: self)
        }
    }
    
    
    @IBAction func btnTermsandConditionsClickEvent(_ sender: Any) {
    }
    
    
    @IBAction func btnPrivacyPolicyClickEvent(_ sender: Any) {
    }
    
    
    @IBAction func btnLoginClickEvent(_ sender: Any) {
        
        let vc = SignInVC.init(nibName: "SignInVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
