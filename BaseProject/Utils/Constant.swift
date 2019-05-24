//
//  Constant.swift
//  BaseProject
//
//  Created by VPN on 16/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit

class Constant: NSObject {
    static let appName = "ShareCB"
    
    static let BASE_URL = "http://clients.vpninfotech.com/sharecb/api/v1/"
    static let SUB_DOMAIN = "";
    static let Basic_authentication_username = "admin"
    static let Basic_authentication_password = "1234"
    
    
    static let URL_SIGNUP = "security/signup";
    static let URL_SIGNUP_FACEBOOK = "security/facebook_signin";
    static let URL_SIGNUP_GOOGLE = "security/google_signin";

    
    static let URL_SIGNIN = "security/signin";
    static let URL_CHANGE_PASSWORD = "security/change_password";
    static let URL_FORGOT_PASSWORD = "security/forgot_password";
    
    static let user_current_password = "user_current_password"
    static let user_email = "user_email"
    static let user_id = "user_id"


    static let appDelObject = UIApplication.shared.delegate as! AppDelegate

    
    static let GOOGLE_CLIENT_ID = "369061996480-ci9fuh9odn8u8qkp1n5oe0g5c2c0etrf.apps.googleusercontent.com";
    
    
    static let FacebookID = "255621891664711";
    
    static let FONT_MEDIUM = UIFont(name: "Arial", size: 16)
   
    static let apcolor = UIColor(red: 23.0/255.0, green: 134.0/255.0, blue: 193.0/255.0, alpha: 1.0);
    
    static let backgroundColor = UIColor(red: 23.0/255.0, green: 134.0/255.0, blue: 193.0/255.0, alpha: 1.0);

    static let buttonColorDark = UIColor(red: 23.0/255.0, green: 134.0/255.0, blue: 193.0/255.0, alpha: 1.0);
    
    static let buttonColorLight = UIColor(red: 23.0/255.0, green: 134.0/255.0, blue: 193.0/255.0, alpha: 1.0);
    
    static let navigationBarColor = UIColor(red: 6.0/255.0, green: 54.0/255.0, blue: 60.0/255.0, alpha: 1.0);

    static let textColor = UIColor(red: 23.0/255.0, green: 134.0/255.0, blue: 193.0/255.0, alpha: 1.0);

    static let textColorSelected = UIColor(red: 23.0/255.0, green: 134.0/255.0, blue: 193.0/255.0, alpha: 1.0);

    static let textColorNonSelected = UIColor(red: 23.0/255.0, green: 134.0/255.0, blue: 193.0/255.0, alpha: 1.0);
    
    static let app_bg_image = UIImage.init(contentsOfFile: "");
    static let app_default_image = UIImage.init(contentsOfFile: "")
    static let app_textfeild_bg_image = UIImage.init(contentsOfFile: "")
    static let app_button_bg_image = UIImage.init(contentsOfFile: "")
    static let app_navigationbar_header_image = UIImage.init(contentsOfFile: "")

    static let alertButtonColor = UIColor(red: 20.0/255.0, green: 153.0/255.0, blue: 174.0/255.0, alpha: 1.0);
    
//    static let UIFont ExoRegularFont(CGFloat size) {
//    return [UIFont fontWithName:@"Exo-Regular" size:size];
//    }
    

}

extension String {
    
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
    
}
