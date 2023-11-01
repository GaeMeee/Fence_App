import UIKit
import RxSwift
import SnapKit
import FirebaseAuth


class AuthenticationView: UIView {
    
    private let disposeBag = DisposeBag()
    
    let authenticationSuccessful = PublishSubject<Void>()
    let tapOutsideTextField = PublishSubject<Void>()
    let keyboardHeight = PublishSubject<CGFloat>()
    let deinitAuthView = PublishSubject<Void>()
    
    private lazy var sendAuthButton = UIButton(type: .custom)
        .withSFImage(systemName: "paperplane.circle", pointSize: 30)
        .withTarget(self, action: #selector(sendAuthButtonTapped))
    
    private lazy var phoneNumberTextField = UITextField()
        .withPlaceholder("Phone Number")
        .withBottomBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
        .withInsets(left: 5, right: 50)
    
    private lazy var authNumberTextField = UITextField()
        .withPlaceholder("Auth Number")
        .withBottomBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
        .withInsets(left: 5, right: 20)
        .withSecured()
    
    private lazy var signupButton = UIButton()
        .withTitle("Sign Up")
        .withBorder(color: UIColor(hexCode: "04364A"), width: 3.0)
        .withBlurEffect()
        .withCornerRadius(20)
        .withTextColor(.black)
        .withTarget(self, action: #selector(signupButtonTapped))
    
    private lazy var cancelButton = UIButton()
        .withTitle("Cancel")
        .withBorder(color: UIColor(hexCode: "04364A"), width: 3.0)
        .withBlurEffect()
        .withCornerRadius(20)
        .withTextColor(.black)
        .withTarget(self, action: #selector(cancelButtonTapped))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupValidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(Self.self) is being deinitialized")
    }
}

//MARK: - configure UI

extension AuthenticationView {
    
    func setupUI() {
        self.backgroundColor = UIColor(hexCode: "CBEDC4")
        
        addSubviews(phoneNumberTextField,authNumberTextField,signupButton,sendAuthButton,cancelButton)
        phoneNumberTextField.rightView = sendAuthButton
        phoneNumberTextField.rightViewMode = .always
        configureConstraints()
    }
    
    func configureConstraints() {
        
        phoneNumberTextField
            .withSize(widthRatioOfSuperview: 0.7)
            .withHeight(40)
            .putAbove(authNumberTextField, 50)
            .positionCenterX()
        
        authNumberTextField
            .withSize(widthRatioOfSuperview: 0.7)
            .withHeight(40)
            .positionCenterX()
            .positionCenterY()
        
        signupButton
            .withSize(widthRatioOfSuperview: 0.7)
            .withHeight(40)
            .putBelow(authNumberTextField, 30)
            .positionCenterX()
        
        cancelButton
            .withSize(widthRatioOfSuperview: 0.7)
            .withHeight(40)
            .putBelow(signupButton, 20)
            .positionCenterX()
    }
}

//MARK: - isValid TextField Format
extension AuthenticationView {
    func setupValidate() {
        phoneNumberTextField.setupForValidation(type: .phoneNumber)
        authNumberTextField.setupForValidation(type: .authNumber)
        setupSignupButtonValidate()
    }
    
    func setupSignupButtonValidate() {
        Observable.combineLatest(
            phoneNumberTextField.validationHandler!.isValidRelay,
            authNumberTextField.validationHandler!.isValidRelay
        ) { phoneNumberIsValid, authNumberIsValid in
            return phoneNumberIsValid && authNumberIsValid
        }
        .do(onNext: {[weak self] isEnabled in
            DispatchQueue.main.async {
                if isEnabled {
                    self?.signupButton.layer.borderColor = UIColor(hexCode: "68B984").cgColor
                } else {
                    self?.signupButton.layer.borderColor = UIColor(hexCode: "04364A").cgColor
                }
            }
        })
        .bind(to: signupButton.rx.isEnabled)
        .disposed(by: disposeBag)
    }
}

//MARK: - Action
extension AuthenticationView {
    
    @objc func sendAuthButtonTapped() {
        
        
        let phoneNumber = self.phoneNumberTextField.text ?? ""
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
            guard let self = self else { return }
            if let error = error { print("Error during phone number verification: \(error.localizedDescription)"); return }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        
        }
    }
    
    @objc func signupButtonTapped() {
        authWithMessage()
        
    }
    
    
    @objc func cancelButtonTapped() {
        
        self.deinitAuthView.onNext(())
        
        
    }
    
    
}



//MARK: - Message Authentication
extension AuthenticationView {
    
    func authWithMessage() {
        guard let verificationCode = authNumberTextField.text else {
            print("Error: Verification code is missing.")
            return
        }
        
        guard let verificationID = fetchVerificationIDFromUserDefaults() else {
            print("Error: VerificationID retrieval failed.")
            return
        }
        
        authenticateUser(verificationID: verificationID, verificationCode: verificationCode)
    }
    
    private func fetchVerificationIDFromUserDefaults() -> String? {
        let storedVerificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        clearVerificationIDFromUserDefaults()
        return storedVerificationID
    }
    
    private func clearVerificationIDFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "authVerificationID")
    }
    
    private func authenticateUser(verificationID: String, verificationCode: String) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { [weak self](authResult, error) in
            if let error = error {print("\(error.localizedDescription)");return}
            self?.deletePhoneNumber()
            print("Successfully signed in with phone number!")
        }
    }
    
    
    func deletePhoneNumber() {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
            } else {
                print("User successfully deleted")
                
                self.authenticationSuccessful.onNext(())
            }
        }
    }
}

