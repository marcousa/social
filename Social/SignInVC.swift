//
//  SignInVC.swift
//  Social
//
//  Created by Marco De Filippo on 11/4/16.
//  Copyright © 2016 2AM App Labs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookButtonTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print(error.debugDescription)
                print("APP: Unable to authenticate with Facebook")
            } else if result?.isCancelled == true {
                print("APP: User cancelled authentication")
            } else {
                print("APP: Successfully authenticated with Facebook")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuthenticate(credential)
            }
        }
        
    }
    
    func firebaseAuthenticate(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("APP: Unable to authenticate with Firebase")
            } else {
                print("APP: Successfully authenticated with Firebase")
            }
        })
        
    }

}

