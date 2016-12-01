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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let keychainUID = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("APP: Keychain ID: \(keychainUID)")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        } else {
            print("APP: Didn't find a keychain ID...loading login screen")
        }
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
                
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
        
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    print("APP: Authenticated successfully via email with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            print("APP: error creating new user in Firebase using email")
                        } else {
                            print("APP: User created in Firebase with email")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                        
                    })
                }
                
            })
            
        } else {
            print("APP: No text entered in the email or password field")
        }
        
    }

    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainSaved = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        if keychainSaved {
            print("APP: ID saved to keychain successfully")
        } else {
            print("APP: Error saving ID to keychain")
        }
        
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

    
}

