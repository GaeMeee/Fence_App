

import UIKit
import RxSwift
import RxCocoa




class ValidationHandler {
    
    let disposeBag = DisposeBag()
    let textSubject = BehaviorSubject<String?>(value: "")
    let isValidRelay: BehaviorRelay<Bool>
    let validationType: ValidationType
    
    enum ValidationType {
        case email
        case phoneNumber
        case password
        case nickName
        case authNumber
    }
    
    init(type: ValidationType) {
        self.validationType = type
        self.isValidRelay = BehaviorRelay<Bool>(value: false)
        setupValidation()
    }
    
    private func setupValidation() {
        switch validationType {
        case .email:
            textSubject
                .map { self.isValidEmail($0) }
                .bind(to: isValidRelay)
                .disposed(by: disposeBag)
                
        case .phoneNumber:
            textSubject
                .map { self.isValidPhoneNumber($0) }
                .bind(to: isValidRelay)
                .disposed(by: disposeBag)
                
        case .password:
            textSubject
                .map { self.isValidPassWord($0)}
                .bind(to: isValidRelay)
                .disposed(by: disposeBag)
            
        case .nickName:
            textSubject
                .map { self.isValidNickName($0)}
                .bind(to: isValidRelay)
                .disposed(by: disposeBag)
            
        case .authNumber:
            textSubject
                .map { self.isValidAuthNumber($0)}
                .bind(to: isValidRelay)
                .disposed(by: disposeBag)
        }
    }
}


//MARK: - Regular Expression
extension ValidationHandler {
    
    func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPhoneNumber(_ phone: String?) -> Bool {
        guard let phone = phone else { return false }
        let phoneNumberFormat = "^010[0-9]{7,8}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberFormat)
        return phonePredicate.evaluate(with: phone)
    }
    
    func isValidPassWord(_ password: String?) -> Bool {
        guard let password = password else { return false }
        return password.count >= 6 ? true : false
    }

    func isValidNickName(_ nickName: String?) -> Bool {
        guard let nickName else {return false}
        return nickName.count >= 6 ? true : false
    }
    
    func isValidAuthNumber(_ authNumber: String?) -> Bool {
        guard let authNumber else {return false}
        return authNumber.count >= 6 ? true : false
    }
}

//MARK: - Associtated Object
extension UITextField {
    
    private struct AssociatedKeys {
        static var validationHandler = "validationHandler"
    }
    
    var validationHandler: ValidationHandler? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.validationHandler) as? ValidationHandler
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.validationHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setupForValidation(type: ValidationHandler.ValidationType) -> Self {
        let initialColor = UIColor(hexCode: "6C5F5B")
        self.withBottomBorder(color: initialColor, width: 3.0)
        
        if validationHandler == nil {
            validationHandler = ValidationHandler(type: type)
        }
        
        validationHandler!.textSubject.onNext(self.text)
        
        self.rx.text
            .bind(to: validationHandler!.textSubject)
            .disposed(by: validationHandler!.disposeBag)
        
        validationHandler!.isValidRelay
            .subscribe(onNext: { [weak self] isValid in
                DispatchQueue.main.async {
                    let borderColor = isValid ? UIColor(hexCode: "55BCEF") : UIColor(hexCode: "A9A9A9")
                    self?.withBottomBorder(color: borderColor, width: 3.0)
                }
            })
            .disposed(by: validationHandler!.disposeBag)
        return self
    }
}
