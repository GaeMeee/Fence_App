//
//  Constant.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import FirebaseFirestore
import FirebaseStorage



let COLLECTION_USERS = Firestore.firestore().collection(FB.Collection.userList)

let COLLECTION_LOST = Firestore.firestore().collection(FB.Collection.lostList)

let COLLECTION_FOUND = Firestore.firestore().collection(FB.Collection.foundList)

let COLLECTION_COMMENTS = Firestore.firestore().collection(FB.Collection.commentList)

let COLLECTION_GROUP_COMMENTS = Firestore.firestore().collectionGroup(FB.Collection.commentList)

let IMAGE_STORAGE = Storage.storage()




