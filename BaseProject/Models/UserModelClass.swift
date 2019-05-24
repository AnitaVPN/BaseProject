//
//  UserModelClass.swift
//  BaseProject
//
//  Created by VPN on 20/06/18.
//  Copyright © 2018 VPN. All rights reserved.
//

import UIKit

class UserModelClass: NSObject {

    var user_id = String()
    var user_name = String()
    var first_name = String()
    var last_name = String()
    var email_address = String()
    var phone_number = String()
    var profile_image = String()
    var acess_token = String()
    var loginType = String()
    var user_role = String()
    var address = String()
    var gender = String()
    var birth_date = String()
    
    var ip_address = String()
    var provider = String()
    var last_login = String()
    var created_at = String()
    var updated_at = String()

    
    
    open func initDict(dict: NSMutableDictionary) -> UserModelClass
    {
        self.user_id = dict.value(forKey: "id") as! String
//        self.ip_address = dict.value(forKey: "ip_address") as! String
//        self.provider = dict.value(forKey: "provider") as! String
        self.profile_image = dict.value(forKey: "userimage") as! String
        self.email_address = dict.value(forKey: "email") as! String
        self.first_name = dict.value(forKey: "first_name") as! String
        self.last_name = dict.value(forKey: "last_name") as! String
//        self.last_login = dict.value(forKey: "last_login") as! String
//        self.created_at = dict.value(forKey: "created_at") as! String
//        self.updated_at = dict.value(forKey: "updated_at") as! String
        return self
        
    }

    
}
