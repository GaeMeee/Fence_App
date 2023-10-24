//
//  firebaseFoundService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

struct FirebaseLostService {
    
    
    let firebaseLostCommentService: FirebaseLostCommentService
    
    func createLost(lostResponseDTO: LostResponseDTO) async throws {
        
        let dictionary = LostResponseDTOMapper.makeDictionary(from: lostResponseDTO)
        
        try await COLLECTION_LOST.document(lostResponseDTO.lostIdentifier).setData(dictionary)
    }
    
    
    func editUserInformationOnLostDTO(with userResponseDTO: UserResponseDTO, batchController: BatchController) async throws {
        
        let identifiers = try await _fetchLostsIdentifier(with: userResponseDTO.identifier)
        
        identifiers.forEach { identifier in
            batchController.batch.updateData([FB.Lost.userProfileImageURL: userResponseDTO.profileImageURL,
                                              FB.Lost.userNickName: userResponseDTO.nickname],
                                             forDocument: COLLECTION_LOST.document(identifier))
        }
    }
    
    
    func deleteLost(lostIdentifier: String) async throws {
        
        let batchController = BatchController()
        
        let ref = COLLECTION_LOST.document(lostIdentifier)
        
        batchController.batch.deleteDocument(ref)
        
        try await firebaseLostCommentService.deleteComments(lostIdentifier: lostIdentifier, batchController: batchController)
        
        try await batchController.batch.commit()
    }
    
    
    func editLost(on lostResponseDTO: LostResponseDTO) async throws {
        
        let dictionary = LostResponseDTOMapper.makeDictionary(from: lostResponseDTO)
        
        try await COLLECTION_LOST.document(lostResponseDTO.lostIdentifier).updateData(dictionary)
        
    }
    
    
    func deleteLosts(writtenBy userIdentifier: String, batchController: BatchController) async throws {
        
        let lostIdentifiers = try await _fetchLostsIdentifier(with: userIdentifier)
        
        await withThrowingTaskGroup(of: type(of: ())) { group in
            for lostIdentifier in lostIdentifiers {
                
                let ref = COLLECTION_LOST.document(lostIdentifier)
                
                batchController.batch.deleteDocument(ref)
                
                group.addTask {
                    try await firebaseLostCommentService.deleteComments(lostIdentifier: lostIdentifier, batchController: batchController)
                }
            }
        }
    }
    
    
    func listenToUpdateOn(userIdentifier: String, completion: @escaping (Result<[LostResponseDTO],Error>) -> Void) {
        COLLECTION_LOST.whereField(FB.Lost.userIdentifier, isEqualTo: userIdentifier).addSnapshotListener { snapshot, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            
            guard let documents = snapshot?.documents else {
                completion(.failure(PetError.noSnapshotDocument))
                return
            }
            
            let lostResponseDTOs = documents.map { document in
                
                let dictionary = document.data()
                
                return LostResponseDTOMapper.makeLostResponseDTO(from: dictionary)
            }
            
            completion(.success(lostResponseDTOs))
            
            
        }
        
    }
    
    
    func fetchLosts() async throws -> [LostResponseDTO] {
        
        let documents = try await COLLECTION_LOST.getDocuments().documents
        
        let lostResponseDTOs = documents.map { document in
            return LostResponseDTOMapper.makeLostResponseDTO(from: document.data())
        }
        
        return lostResponseDTOs
        
        
    }
    
    
    init(firebaseLostCommentService: FirebaseLostCommentService) {
        
        self.firebaseLostCommentService = firebaseLostCommentService
    }
    
    //MARK: - Helper
    
    func _fetchLostsIdentifier(with userIdentifier: String) async throws -> [String] {
        
        let query = COLLECTION_LOST.whereField(FB.Lost.userIdentifier, isEqualTo: userIdentifier)
        
        let documents = try await query.getDocuments().documents
        
        let identifiers = documents.map { document in
            document.data()[FB.Lost.lostIdentifier] as? String ?? ""
        }
        
        return identifiers
    }
}
    
    
    
    
    

