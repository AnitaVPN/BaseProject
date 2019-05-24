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


class extraSignUpVC: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate , GIDSignInUIDelegate,GIDSignInDelegate
{
    
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtEmailAddres: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCPassword: UITextField!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnSingUp: UIButton!
    let util = Utils()
    var strErrMsg = String()
    var imagePicker = UIImagePickerController()
    let api = ServerAPI()
    
    var modelClass = UserModelClass()
    
    @IBOutlet weak var btnGmailSignup: GIDSignInButton!
//    @IBOutlet weak var btnFacebookLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTextFeild()
    }
    
    
    func setupTextFeild()
    {
        util.addLeftViewToTextFeild(textFeild: txtFName, image: #imageLiteral(resourceName: "icon_user"), strPlaceHolder: "", padding: 30)
        util.addLeftViewToTextFeild(textFeild: txtLName, image: #imageLiteral(resourceName: "icon_user"), strPlaceHolder: "", padding: 30)
        util.addLeftViewToTextFeild(textFeild: txtEmailAddres, image: #imageLiteral(resourceName: "icon_email"), strPlaceHolder: "", padding: 30)
        util.addLeftViewToTextFeild(textFeild: txtPassword, image: #imageLiteral(resourceName: "icon_password"), strPlaceHolder: "", padding: 30)
        util.addLeftViewToTextFeild(textFeild: txtCPassword, image: #imageLiteral(resourceName: "icon_password"), strPlaceHolder: "", padding: 30)
        
        imagePicker.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = Constant.GOOGLE_CLIENT_ID;
        GIDSignIn.sharedInstance().delegate = self
        
        
    }
    
    
    func addValidation() -> Bool
    {
        
        if(txtEmailAddres.text == "")
        {
            strErrMsg = "Please enter  Email Address"
            return false
        }
        if(txtPassword.text == "")
        {
            strErrMsg = "Please enter Password"
            return false
        }
        if(txtCPassword.text == "")
        {
            strErrMsg = "Please enter confirm password"
            return false
        }
        if(txtFName.text == "")
        {
            strErrMsg = "Please enter First name "
            return false
        }
        if(txtLName.text == "")
        {
            strErrMsg = "Please enter Last name "
            return false
        }
        if(!util.isValidEmail(testStr: txtEmailAddres.text!))
        {
            strErrMsg = "Please enter correct Email Address"
            return false
        }
        if((txtPassword.text?.count)! < 6 )
        {
            strErrMsg = "Please enter password more then 6 character"
            return false
        }
        if(txtPassword.text != txtCPassword.text )
        {
            strErrMsg = "Password and Confirm password does not match."
            return false
        }
        return true
    }
    
    //MARK:- Button click events
    
    @IBAction func choseProfileClickEvent(_ sender: Any) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default) {
            UIAlertAction in
            self.openLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSignUpClickEvent(_ sender: Any) {
        
        if(addValidation())
        {
            self.API_SIGNUP(type: 0)
        }
        else
        {
            util.displayAlert(strMessage: strErrMsg as NSString, simple: false, vc: self)
        }
    }
    
    @IBAction func btnFacebookLoginClickEvent(_ sender: Any) {
        
        Constant.appDelObject.isFacebookLogin = true;
        self.getFacebookUserInfo();
    }
    
    
    @IBAction func btnGmailLoginClickEvent(_ sender: Any) {
    }
    
    
    //MARK:- ImagePicker methods
    
    func openLibrary() {
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera() {
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:UIImagePickerControllerDelegate
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerController cancel")
    }
    
    
    
    func API_SIGNUP(type : Int)
    {
        SVProgressHUD.setStatus("Please wait ...")
        let dict = NSMutableDictionary()
        var api_url = String()
        
        if(type == 0)
        {
            dict.setValue(txtFName.text, forKey: "firstname");
            dict.setValue(txtLName.text, forKey: "lastname");
            dict.setValue(txtFName.text, forKey: "username");
            dict.setValue(txtEmailAddres.text, forKey: "email");
            dict.setValue("1234567890", forKey: "phone");
            dict.setValue(txtPassword.text, forKey: "password");
            dict.setValue(txtCPassword.text, forKey: "cpassword");
            
            api_url = Constant.URL_SIGNUP
            
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
    
    
    
}
