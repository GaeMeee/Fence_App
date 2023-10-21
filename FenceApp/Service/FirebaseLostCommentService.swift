//
//  FirebaseLostCommentService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

struct FirebaseLostCommentService {
    
    let commentResponseDTOMapper: CommentResponseDTOMapper
    
    func createComment(commentResponseDTO: CommentResponseDTO) async throws {
        
        let dictionary = commentResponseDTOMapper.makeDictionary(commentResponseDTO: commentResponseDTO)
        
        try await COLLECTION_LOST.document(commentResponseDTO.lostIdentifier).collection(FB.Collection.commentList).document(commentResponseDTO.commentIdentifier).setData(dictionary)
    }
    
    func editUserInformationOnComments(with userResponseDTO: UserResponseDTO, batchController: BatchController) async throws {
        
        let tuples: [(String, String)] = try await _fetchCommentIdentifiers(with: userResponseDTO.identifier)
        
        tuples.forEach { (lostIdentifier, commentIdentifier) in
            let ref = COLLECTION_LOST.document(lostIdentifier).collection(FB.Collection.commentList).document(commentIdentifier)
            batchController.batch.updateData([FB.Comment.userProfileImageURL: userResponseDTO.profileImageURL, FB.Comment.userNickname: userResponseDTO.nickname], forDocument: ref)
        }

    }
    
    func editComment(on commentResponseDTO: CommentResponseDTO) async throws {
       
        let ref = COLLECTION_LOST.document(commentResponseDTO.lostIdentifier).collection(FB.Collection.commentList).document(commentResponseDTO.commentIdentifier)
        
        let dictionary = commentResponseDTOMapper.makeDictionary(commentResponseDTO: commentResponseDTO)
        
        try await ref.updateData(dictionary)
        
    }
    
    func fetchComments(lostIdentifier: String) async throws -> [CommentResponseDTO] {
        
        let documents = try await COLLECTION_LOST.document(lostIdentifier).collection(FB.Collection.commentList).getDocuments().documents
        
        let comments = documents.map { document in
            
            commentResponseDTOMapper.makeCommentResponseDTO(dictionary: document.data())
        }
       
        return comments
    }
    
    func deleteComment(lostIdentifier: String, commentIdentifier: String) async throws {
        
        let ref = COLLECTION_LOST.document(lostIdentifier).collection(FB.Collection.commentList).document(commentIdentifier)
        
        try await ref.delete()
    }
    
    func deleteComments(lostIdentifier: String, batchController: BatchController) async throws {
        
        let query = COLLECTION_LOST.document(lostIdentifier).collection(FB.Collection.commentList)
        
        let documents = try await query.getDocuments().documents

        documents.forEach { document in
            
            let commentIdentifier = document.data()[FB.Comment.commentIdentifier] as? String ?? ""
    
            let ref = COLLECTION_LOST.document(lostIdentifier).collection(FB.Collection.commentList).document(commentIdentifier)
            
            batchController.batch.deleteDocument(ref)
            
        }
    }
    
    //MARK: - Helper
    
   private func _fetchCommentIdentifiers(with userIdentifier: String) async throws -> [(String, String)] {
        
        let query = COLLECTION_GROUP_COMMENTS.whereField(FB.Comment.userIdentifier, isEqualTo: userIdentifier)
        
        let documents = try await query.getDocuments().documents
        
        let tuples: [(String, String)] = documents.map { document in
            
            let lostIdentifier = document.data()[FB.Comment.lostIdentifier] as? String ?? ""
            let commentIdentifier = document.data()[FB.Comment.commentIdentifier] as? String ?? ""
            
            return (lostIdentifier, commentIdentifier)
        }
        
        return tuples
    }
    
    init(commentResponseDTOMapper: CommentResponseDTOMapper) {
        self.commentResponseDTOMapper = commentResponseDTOMapper
    }
    
    
}
