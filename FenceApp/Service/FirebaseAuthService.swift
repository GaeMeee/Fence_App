//
//  FirebaseAuthService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation
import FirebaseAuth

struct FirebaseAuthService {
    
    let firebaseUserService: FirebaseUserService
    let firebaseLostService: FirebaseLostService
    let firebaseLostCommentService: FirebaseLostCommentService
    let firebaseFoundService: FirebaseFoundService
    
    func signUpUser(email: String, password: String) async throws -> AuthDataResult {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        
        return authResult
        
    }
    
    func signInUser(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        print(result.user)
        
    }
    
    func sendPasswordReset(withEmail: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: withEmail)
        
    }
    
    func signOutUser() throws {
        try Auth.auth().signOut()
    }
    
    func checkIfUserLoggedIn() -> Bool  {
        
        return Auth.auth().currentUser == nil ? false : true
    }
    
    func getCurrentUser() throws -> User {
        
        guard let user = Auth.auth().currentUser else { throw PetError.noUser }
        
        return user
    }
    
    func deleteUser(email: String, password: String) async throws {
        
        let batchController = BatchController()
        
        let user = try getCurrentUser()
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        try await user.reauthenticate(with: credential)
        
        // group task 추가해야함
        
        try await user.delete()
        
        try await firebaseUserService.deleteUser(userIdentifier: user.uid, batchController: batchController)
        
        try await firebaseLostService.deleteLosts(writtenBy: user.uid, batchController: batchController)
        
        try await firebaseLostCommentService.deleteComments(writtenBy: user.uid, batchController: batchController)
        
        try await firebaseFoundService.deleteFounds(writtenBy: user.uid, batchController: batchController)
        
        try await batchController.batch.commit()
    }
   
    func updatePassword(currentPassword: String, newPassword: String) async throws {
        
        let user = try getCurrentUser()
        
        guard let email = user.email else { throw PetError.noEmail }
        
        let credential = authenticateUser(email: email, currentPassword: currentPassword)
        
        try await user.reauthenticate(with: credential)
        
        try await user.updatePassword(to: newPassword)
        
        
    }
    
    private func authenticateUser(email: String, currentPassword: String) -> AuthCredential {
        
        return EmailAuthProvider.credential(withEmail: email, password: currentPassword)
    }
    
    init(firebaseUserService: FirebaseUserService, firebaseLostService: FirebaseLostService, firebaseLostCommentService: FirebaseLostCommentService, firebaseFoundService: FirebaseFoundService) {
        self.firebaseUserService = firebaseUserService
        self.firebaseLostService = firebaseLostService
        self.firebaseLostCommentService = firebaseLostCommentService
        self.firebaseFoundService = firebaseFoundService
    }

}
