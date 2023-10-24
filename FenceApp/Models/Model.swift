//
//  Model.swift
//  FenceApp
//
//  Created by ㅣ on 2023/10/16.
//

import UIKit








struct Comment {
    
    let commentIdentifier: String
    let userIdentifier: String
    var userProfileImageURL: String
    var userNickname: String
    var description: String
    let date: Date
    
    static var dummyComment: [Comment] = [
        Comment(commentIdentifier: "comment1", userIdentifier: "user1", userProfileImageURL: "url1", userNickname: "nickname1", description: "description1", date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!)
//        Comment(user: User.dummyUser[0], description: "description1", date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!),
//        Comment(user: User.dummyUser[1], description: "description2", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
//        Comment(user: User.dummyUser[2], description: "description3", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
//        Comment(user: User.dummyUser[3], description: "description4", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
//        Comment(user: User.dummyUser[4], description: "description5", date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!),
    ]
}
