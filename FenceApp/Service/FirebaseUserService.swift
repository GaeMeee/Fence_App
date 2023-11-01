//
//  FirebaseUserService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//



struct FirebaseUserService {
    
    //MARK: - Properties
    
    let firebaseLostService: FirebaseLostService
    let firebaseLostCommentService: FirebaseLostCommentService
    
    
    func createUser(userResponseDTO: UserResponseDTO) async throws {
        
        let dictionary = UserResponseDTOMapper.makeDictionary(from: userResponseDTO)
        
        try await COLLECTION_USERS.document(userResponseDTO.identifier).setData(dictionary)
    }
    
    
    func fetchUser(userIdentifier: String) async throws -> UserResponseDTO {
        
        guard let dictionary = try await COLLECTION_USERS.document(userIdentifier).getDocument().data() else { throw PetError.noSnapshotDocument }
        
        let userDTO = UserResponseDTOMapper.makeUserResponseDTO(from: dictionary)
        
        return userDTO
    }
    

    
    func editUser(userResponseDTO: UserResponseDTO) async throws {
        
        let batchController = BatchController()
        
        _editUser(userResponseDTO: userResponseDTO, batchController: batchController)
        
        await withThrowingTaskGroup(of: type(of: ())) { group in
            
                group.addTask {
                    try await firebaseLostService.editUserInformationOnLostDTO(with: userResponseDTO, batchController: batchController)
                    try await firebaseLostCommentService.editUserInformationOnComments(with: userResponseDTO, batchController: batchController)
                }
            }
        
        try await batchController.batch.commit()
    }
    
    
    func deleteUser(userIdentifier: String, batchController: BatchController) async throws {
        let ref = COLLECTION_USERS.document(userIdentifier)
        
        batchController.batch.deleteDocument(ref)
        
    }
    
    
    func listenToUpdateOn(userIdentifier: String, completion: @escaping (Result<UserResponseDTO,Error>) -> Void) {
        COLLECTION_USERS.document(userIdentifier).addSnapshotListener { snapshot, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let dictionary = snapshot?.data() else {
                completion(.failure(PetError.noSnapshotDocument))
                return
            }
            
            let userResponseDTO = UserResponseDTOMapper.makeUserResponseDTO(from: dictionary)
            
            completion(.success(userResponseDTO))
        
        }
        
    }
    
    
    init(firebaseLostService: FirebaseLostService,
         firebaseLostCommentService: FirebaseLostCommentService) {
        
        self.firebaseLostService = firebaseLostService
        self.firebaseLostCommentService = firebaseLostCommentService
    }
    
    //MARK: - Helper
    
    private func _editUser(userResponseDTO: UserResponseDTO, batchController: BatchController) {
        let ref = COLLECTION_USERS.document(userResponseDTO.identifier)
        
        let dictionary = UserResponseDTOMapper.makeDictionary(from: userResponseDTO)
        
            batchController.batch.updateData(dictionary, forDocument: ref)
        
    }
   
}
