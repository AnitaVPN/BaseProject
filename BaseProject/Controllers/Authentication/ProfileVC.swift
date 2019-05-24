//
//  ProfileVC.swift
//  BaseProject
//
//  Created by VPN on 16/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate{

    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var btnUpdateProfile: UIButton!
    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var btnChangeProfilePic: UIButton!
    @IBOutlet weak var txtLName: UITextField!
    let model = UserModelClass()

    var selectedImage = UIImage()
    
    var imagePicker = UIImagePickerController()
    var api = ServerAPI()
    var util = Utils()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        self.navigationController?.view.tintColor = UIColor.white
        setupUserData()

        btnUpdateProfile.layer.cornerRadius = 25;
        btnUpdateProfile.clipsToBounds = true;
        
        txtFname.delegate = self;
        
        btnProfileImage.layer.cornerRadius = btnProfileImage.frame.size.width/2;
        btnProfileImage.clipsToBounds = true;
        
        API_LOAD_PROFILE();
        setupUserData()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    @objc func rightButtonAction(sender: UIBarButtonItem)
    {
        let util = Utils()
        util.displayAlert(strMessage: "Feature will comming soon", simple: true, vc: self)
    }
    
    func setupUserData()
    {
        txtFname.text = Constant.appDelObject.userModelClass.first_name
        txtLName.text = Constant.appDelObject.userModelClass.last_name
    
        
        if(Constant.appDelObject.userModelClass.profile_image == "")
        {
            btnProfileImage.backgroundColor = UIColor.black
            btnProfileImage.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
            self.selectedImage = (btnProfileImage.imageView?.image!)!
        }
        else
        {
            
            
            btnProfileImage.backgroundColor = UIColor.black
            
            btnProfileImage.sd_setImage(with: NSURL.init(string: Constant.appDelObject.userModelClass.profile_image)! as URL, for: .normal, placeholderImage: #imageLiteral(resourceName: "profile"), options: .refreshCached) { (img, err, cachheType, url) in
                
                DispatchQueue.main.async {
                    if(img != nil)
                    {
                        
                        self.btnProfileImage.backgroundColor = UIColor.clear
                        self.selectedImage = img!
                    }
                    else
                    {
                        self.selectedImage = #imageLiteral(resourceName: "profile")
                    }
                }
            }
            
          
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    @IBAction func btnChangePasswordClickEvent(_ sender: Any)
    {
        let vc = ChangePasswordVC.init(nibName: "ChangePasswordVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnUpdateProfileClickEvent(_ sender: Any) {
        self.updateProfile_API()

    }
    
    @IBAction func btnChangeProfileImageClickEvent(_ sender: Any) {
        
        tapOnButton()
    }
    
    func openCameraButton(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func addImageOnTapped(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    //picker pick image and store value imageview
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
          
            btnProfileImage.setImage(image, for: .normal)
            imagePicker.dismiss(animated: true, completion: nil);
            
            selectedImage = image;
        }
    }
    
    func tapOnButton(){
        let optionMenu = UIAlertController(title: nil, message: "Please select option for profile image", preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.addImageOnTapped()
        })
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.openCameraButton()
        })
        
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancleAction)
        
//        optionMenu.so
//        optionMenu.s
        self.present(optionMenu, animated: true, completion: nil)
    }

    
    //MARK:- API for update profile
    func updateProfile_API()
    {
        self.selectedImage = (btnProfileImage.imageView?.image)!
       
        let dict = NSMutableDictionary()
        dict.setValue(self.selectedImage, forKey: "userfile")
        dict.setValue(txtFname.text, forKey: "firstname")
        dict.setValue(txtLName.text, forKey: "lastname")
        dict.setValue(UserDefaults.standard.value(forKey: Constant.user_id) as! String, forKey: "id")

        print(dict)
//        api.upload(scanImage: selectedImage, URL: Constant.BASE_URL + "api/User/PostUserImage", secretKey: Constant.appDelObject.userModelClass.Secret, DisplayName: txtuserName.text!)
        
        
        api.UPLOAD_IMAGE_API_CALL(str:"users/update_profile", isApplyToken: false, isAppliedBasicAuthentication: true, dict: dict, queryStr: "test", image: (self.selectedImage), onSuccess: { (json) in
            
            print(json)
            
//            if(json != nil)
//            {
//                let dict = json as? NSDictionary;()
//                if((dict?.count)! > 0)
//                {
//                    if(dict?.value(forKey: error) != nil)
//                    {
//                        util.displayAlert(strMessage: dict?.value(forKey: error) as! String, simple: true, vc: self)
//                    }
//                }
//
//
//            }
            
            
            
        }) { (err) in
            
//            DispatchQueue.main.async {
//                self.util.displayAlert(strMessage: err?.localizedDescription! as NSString, simple: true, vc: self)
//            }
            print(err?.localizedDescription)
        }
        

        
    }
    
    
    func API_LOAD_PROFILE()
    {
        let dict = NSMutableDictionary()
        dict.setValue(UserDefaults.standard.value(forKey: Constant.user_id) as! String, forKey: "id")

        api.POST_API_CALL(str: "/users/load_profile", isApplyToken: false, isAppliedBasicAuthentication: true, dict: dict, queryStr: "test", onSuccess: { (json) in
            
            if(json != nil)
                        {
                            let dictParse = json as? NSDictionary
                            let sucess = dictParse?.value(forKey: "response") as? Bool
                            
                            if(sucess)!
                            {
                                DispatchQueue.main.async {
                                    let arr = dictParse?.value(forKey: "data") as? NSDictionary
                                    print(arr?.count);
                                    SVProgressHUD.dismiss()
                                    
                                    Constant.appDelObject.userModelClass = self.model.initDict(dict: NSMutableDictionary.init(dictionary: arr!));
                                    
                                    self.setupUserData()
                                    
                                    UserDefaults.standard.set(arr?.value(forKey: "id") as? String, forKey: Constant.user_id)
                                    UserDefaults.standard.synchronize()
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
                                    self.util.displayAlert(strMessage: msg! as NSString, simple: false, vc: self)
                                }
                                else
                                {
                                    self.util.displayAlert(strMessage: errMsg as! NSString, simple: false, vc: self)
                                    
                                }
                            }
            
                        }
            
        }) { (err) in
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtFname.resignFirstResponder()
        txtLName.resignFirstResponder()

        return true
    }
    
}
