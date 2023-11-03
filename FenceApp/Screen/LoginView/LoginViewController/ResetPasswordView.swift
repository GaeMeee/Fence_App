import UIKit
import FirebaseAuth
import RxSwift
import RxKeyboard
import RiveRuntime

class ResetPasswordView: UIView {
    
    let disposeBag = DisposeBag()
    
    let resetEmailSent = PublishSubject<Void>()
    let deinitResetPasswordView = PublishSubject<Void>()
    
    private lazy var titleLabel = UILabel()
        .withText("비밀번호 변경")
        .withFont(30, fontName: "Binggrae-Bold")
        .withTextColor(UIColor(hexCode: "6C5F5B"))
    
    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email")
        .withInsets(left: 5, right: 20)
    
    private lazy var resetPasswordButton = UIButton()
        .withTitle("비밀번호 재설정하기")
        .withTextColor(UIColor(hexCode: "6C5F5B"))
        .withTarget(self, action: #selector(resetPasswordButtonTapped))
        .withCornerRadius(15)
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
        .withBlurEffect()
    
    private lazy var cancelButton = UIButton()
        .withTitle("뒤로가기")
        .withTextColor(UIColor(hexCode: "6C5F5B"))
        .withTarget(self, action: #selector(cancelButtonTapped))
        .withCornerRadius(15)
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
        .withBlurEffect()
    
    deinit {
        print("ResetPasswor Deinit")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        emailTextField
            .updateBottomBorder(color: UIColor(hexCode: "04364A"), width: 3)
            .setupForValidation(type: .email)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        handleKeyboardAdjustment(adjustmentFactor: 0.1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - UI Setup

extension ResetPasswordView {
    func setupUI() {
        
        self.backgroundColor = .white
        addSubviews(emailTextField, resetPasswordButton,cancelButton,titleLabel)
        configureConstraints()
    }
    
    
    func configureConstraints() {
        
        titleLabel
            .positionCenterX()
            .putAbove(emailTextField, 40)

        emailTextField
            .positionCenterX()
            .positionCenterY()
            .withSize(widthRatioOfSuperview: 0.8)
            .withHeight(40)

        resetPasswordButton
            .putBelow(emailTextField, 20)
            .positionCenterX()
            .withSize(widthRatioOfSuperview: 0.6)
            .withHeight(40)
        
        cancelButton
            .putBelow(resetPasswordButton, 20)
            .positionCenterX()
            .withSize(widthRatioOfSuperview: 0.6)
            .withHeight(40)

    }
}

// MARK: - Actions

extension ResetPasswordView {
    
    @objc func resetPasswordButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showInvalidEmailAlert()
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] (error) in
            if let error = error {
                self?.showErrorAlert(message: error.localizedDescription)
                return
            }
            
            self?.resetEmailSent.onNext(())
        }
    }
    
    func showInvalidEmailAlert() {
        showAlert(title: "Invalid Input", message: "Please enter a valid email address.")
    }
    
    func showErrorAlert(message: String) {
        showAlert(title: "Error", message: message)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
    }
    
    
    @objc func cancelButtonTapped() {
        deinitResetPasswordView.onNext(())
    }
}


//MARK: - isValid TextField Format
extension ResetPasswordView {
    func setupValidate() {
    }
}


//MARK: - Handling keyboard
extension ResetPasswordView {
        
    func adjustForKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                if keyboardHeight > 0 {
                    self?.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 2)
                } else {
                    self?.transform = .identity
                }
            })
            .disposed(by: disposeBag)
    }
}


