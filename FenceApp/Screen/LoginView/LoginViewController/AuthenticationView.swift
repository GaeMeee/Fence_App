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
    
    private lazy var titleLabel = UILabel()
        .withText("번호인증")
        .withFont(30, fontName: "Binggrae-Bold")
        .withTextColor(UIColor(hexCode: "6C5F5B"))

    private lazy var sendAuthButton = UIButton(type: .custom)
        .withSFImage(systemName: "paperplane.circle", pointSize: 30, tintColor: (UIColor(hexCode: "6C5F5B")))
        .withTarget(self, action: #selector(sendAuthButtonTapped))
    
    private lazy var phoneNumberTextField = UITextField()
        .withPlaceholder("전화번호")
        .withInsets(left: 5, right: 50)
        .withBottomBorder(width: 3)
    
    private lazy var authNumberTextField = UITextField()
        .withPlaceholder("인증번호")
        .withInsets(left: 5, right: 20)
        .withSecured()
        .withBottomBorder(width: 3)

    
    private lazy var signupButton = UIButton()
        .withTitle("인증완료")
        .withTextColor(UIColor(hexCode: "6C5F5B"))
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
        .withBlurEffect()
        .withCornerRadius(15)
        .withTarget(self, action: #selector(signupButtonTapped))
    
    private lazy var cancelButton = UIButton()
        .withTitle("뒤로가기")
        .withTextColor(UIColor(hexCode: "6C5F5B"))
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
        .withBlurEffect()
        .withCornerRadius(15)
        .withTarget(self, action: #selector(cancelButtonTapped))
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        phoneNumberTextField
            .setupForValidation(type: .phoneNumber)

        authNumberTextField
            .setupForValidation(type: .authNumber)
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        setupUI()
        
        
    }
    
    deinit {
        print("\(Self.self) is being deinitialized")
    }
}

//MARK: - configure UI

extension AuthenticationView {
    
    func setupUI() {
        self.backgroundColor = UIColor(hexCode: "CBEDC4")
        
        addSubviews(phoneNumberTextField,titleLabel,authNumberTextField,signupButton,sendAuthButton,cancelButton)
        phoneNumberTextField.rightView = sendAuthButton
        phoneNumberTextField.rightViewMode = .always
        configureConstraints()

    }
    
    func configureConstraints() {
        
        titleLabel
            .putAbove(phoneNumberTextField, 40)
            .positionCenterX()

        phoneNumberTextField
            .withSize(widthRatioOfSuperview: 0.7)
            .withHeight(40)
            .putAbove(authNumberTextField, 10)
            .positionCenterX()
        
        authNumberTextField
            .withSize(widthRatioOfSuperview: 0.7)
            .withHeight(40)
            .positionCenterX()
            .positionCenterY()
        
        signupButton
            .withSize(150, 40)
            .putBelow(authNumberTextField, 40)
            .positionCenterX()
        
        cancelButton
            .withSize(150, 40)
            .putBelow(signupButton, 10)
            .positionCenterX()
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
                self.authenticationSuccessful.onNext(())
                print("User successfully deleted")
                
            }
        }
    }
}

