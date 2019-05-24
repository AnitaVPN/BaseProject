//
//  Profile.swift
//  ShareCB
//
//  Created by PC on 15/04/19.
//  Copyright © 2019 VPN. All rights reserved.
//

import UIKit

class Profile: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imgviewprofile: UIImageView!
    
    @IBOutlet weak var txtfirstname: UITextField!
    
    @IBOutlet weak var txtlastname: UITextField!
    
    @IBOutlet weak var txtemail: UITextField!
    
    @IBOutlet weak var txtcurrentpassword: UITextField!
    
    @IBOutlet weak var txtnewpassword: UITextField!
    
    @IBOutlet weak var txtconfirmnewpassword: UITextField!
    
   // @IBOutlet weak var txtprofileimage: UITextField!
    
    @IBOutlet weak var btnprofileimg: UIButton!
    
    
    let utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textfieldbottomborder(textfield: txtfirstname)
        textfieldbottomborder(textfield: txtlastname)
        textfieldbottomborder(textfield: txtemail)
        textfieldbottomborder(textfield: txtcurrentpassword)
        textfieldbottomborder(textfield: txtconfirmnewpassword)
      //  textfieldbottomborder(textfield: txtprofileimage)
        textfieldbottomborder(textfield: txtnewpassword)
        
        let lineView = UIView(frame: CGRect(x: 0, y: btnprofileimg.frame.size.height, width: btnprofileimg.frame.size.width, height: 1))
        lineView.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        btnprofileimg.addSubview(lineView)
        
        let saveme = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        let logoutme = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        saveme.tintColor = UIColor.white
        logoutme.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = saveme
        navigationItem.rightBarButtonItems = [logoutme]
        
        // utils.addLeftViewToTextFeild(textFeild: txtprofileimage, image: UIImage(named: "glass")!, strPlaceHolder: "Browse", padding: 30)
        
        imgviewprofile.layer.borderWidth = 1.0
        imgviewprofile.layer.masksToBounds = false
        imgviewprofile.layer.borderColor = UIColor.clear.cgColor
        imgviewprofile.layer.cornerRadius = imgviewprofile.frame.size.width / 2
        imgviewprofile.clipsToBounds = true
        
        imagePicker.delegate = self
     }
    
    func textfieldbottomborder(textfield:UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0).cgColor
        textfield.borderStyle = UITextField.BorderStyle.none
        textfield.layer.addSublayer(bottomLine)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.topItem?.title = "Profile"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255, green: 53/255, blue: 60/255, alpha: 1.0)
    }
    
    @objc func save(){
        let alert = UIAlertController(title: "Sharecb", message: "save", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func logout(){
        let alert = UIAlertController(title: "Sharecb", message: "logout", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func btnprofileimgtapped(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
        }
        picker.dismiss(animated: true, completion: nil)
    }


}
