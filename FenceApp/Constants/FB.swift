//
//  FirebaseString.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/20/23.
//

struct FB {
    
    struct User {
        static let email = "email"
        static let userNickname = "userNickname"
        static let profileImageURL = "profileImageURL"
        static let useridentifier = "userIdentifier"
    }
    
    struct Lost {
        
        static let lostIdentifier = "lostIdentifier"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let userIdentifier = "userIdentifier"
        static let userProfileImageURL = "userProfileImageURL"
        static let userNickName = "userNickname"
        static let title = "lostTitle"
        static let postDate = "postDate"
        static let lostDate = "petLostDate"
        static let pictureURL = "pictureURL"
        static let petName = "petName"
        static let lostDescription = "lostDescription"
        static let kind = "petKind"
    }
    
    struct Found {
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let imageURL = "imageURL"
        static let date = "date"
        static let userIdentifier = "userIdentifier"
        static let foundIdentifier = "foundIdentifier"
    }
    
    struct Comment {
        static let lostIdentifier = "lostIdentifier"
        static let commentIdentifier = "commentIdentifier"
        static let userIdentifier = "userIdentifier"
        static let userProfileImageURL = "userProfileImageURL"
        static let userNickname = "userNickname"
        static let commentDescription = "commentDescription"
        static let commentDate = "commentDate"
    }
    
    struct Collection {
        static let userList = "user_list"
        static let lostList = "lost_list"
        static let foundList = "found_list"
        static let commentList = "comment_list"
    }
}

