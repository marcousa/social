//
//  DataService.swift
//  Social
//
//  Created by Marco De Filippo on 12/1/16.
//  Copyright © 2016 2AM App Labs. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let ds = DataService()
    

    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
