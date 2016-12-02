//
//  PostCell.swift
//  Social
//
//  Created by Marco De Filippo on 11/11/16.
//  Copyright © 2016 2AM App Labs. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircleImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //Need to add a tap gesture recognizer for the heart in code
        //since for repetitive items it can't be added via storyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    
    }

    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        //get a reference for the current user and check their likes
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postId)
        
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            
            //download the image to the cache
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Error: unable to download image \(post.imageUrl) from Firebase storage")
                } else {
                    print("Image downloaded from Firebase storage")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.postImg.image = image
                            FeedVC.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        //if the user had liked the current post, show a filled heart, otherwise an empty one
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "empty-heart")
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        //If something is already liked, when tapped then it will be unliked...and vice-versa
        //then also add/remove the like reference for that user in Firebase
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
    
}
