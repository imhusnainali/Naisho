//
//  FireBaseManager.swift
//  Naisho
//
//  Created by cao on 2017/03/10.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

class FirebaseFacebookManager:NSObject{
    override init(){
        super.init()
    }
    
    func FireBaseAuthWithFB(){
        let accessToken = FBSDKAccessToken.current()
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        
        // Perform login by calling Firebase APIs
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                
                // Error Handler
                // Generate Alert
                /*
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                */
                return
            }
            
            // Present the main view
            /*
             if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
             UIApplication.shared.keyWindow?.rootViewController = viewController
             self.dismiss(animated: true, completion: nil)
             }*/
            
        })
    }
    
    func getFBLoginButton()->FBSDKLoginButton{
        let loginBtn : FBSDKLoginButton = FBSDKLoginButton();
        loginBtn.readPermissions = ["public_profile", "email", "user_friends"];
        return loginBtn;
    }
    
    func FBGraphRequest(nextCursor : String?){
        var params = Dictionary<String, String>() as? Dictionary
        
        if nextCursor == nil {
            params = nil
        } else {
            params!["after"] = nextCursor
        }
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let json = JSON(result!)
                    for (_,subJson):(String, JSON) in json["data"] {
                        print(subJson["name"])
                    }
                    if(json["paging"]["cursors"]["after"] != nil){
                        self.FBGraphRequest(nextCursor: json["paging"]["cursors"]["after"].string);
                    } else {
                        print("End of Page");
                    }
                    
                }
            })
        }
    }
    

}
