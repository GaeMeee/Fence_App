//MARK: - Module

//Framework
import UIKit
import Security
import PhotosUI

//Library
import RiveRuntime
import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import FirebaseAuth




//MARK: - Properties & Deinit
final class LoginViewController: UIViewController {
    

    let firebaseAuthService: FirebaseAuthService
    let firebaseUserService: FirebaseUserService
    
    let authPassed: () -> Void

    private let alertHandler = AlertHandler()
    private let authView = AuthenticationView()
    private var signUpView: SignUpView?

    private let resetPasswordView = ResetPasswordView()
    
    private var disposeBag = DisposeBag()
    private var emailTextSubject = BehaviorSubject<String?>(value: nil)

    
    private var shadowContainer = UIView()
        .withShadow()

    private lazy var titleLabel = UILabel()
        .withText("찾아줄개")
        .withFont(40, fontName: "Binggrae-Bold")
        .withTextColor(UIColor(hexCode: "6C5F5B"))
    
    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email@gmail.com")
        .withInsets(left: 5, right: 20)
        .withBottomBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
    
    private let passwordTextField = UITextField()
        .withPlaceholder("비밀번호 6글자 이상")
        .withSecured()
        .withInsets(left: 5, right: 20)
        .withBottomBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)

    private lazy var loginButton = UIButton()
        .withTitle("로그인")
        .withTextColor(UIColor(hexCode: "6C5F5B"))
        .withFont(size: 20, fontName: "Binggrae-Regular")
        .withTarget(self, action: #selector(loginButtonTapped))
        .withCornerRadius(15)
        .withBlurEffect()
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
    
    private lazy var signUpButton = UIButton()
        .withTitle("회원 가입")
        .withTextColor(UIColor(hexCode: "6C5F5B"))
        .withFont(size: 20, fontName: "Binggrae-Regular")
        .withTarget(self, action: #selector(signUpButtonTapped))
    
    private lazy var findPasswordButton = UIButton()
        .withTitle("비밀번호 찾기")
        .withTextColor(UIColor(hexCode: "6C5F5B"))
        .withFont(size: 20, fontName: "Binggrae-Regular")
        .withTarget(self, action: #selector(findPasswordButtonTapped))
    
    
    
    private lazy var buttonStack = UIStackView()
        .withAxis(.horizontal)
        .withDistribution(.fillEqually)
        .withSpacing(10)
        .withMargins(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    
    init(firebaseAuthService: FirebaseAuthService, firebaseUserService: FirebaseUserService, authPassed: @escaping () -> Void) {
        self.firebaseAuthService = firebaseAuthService
        self.firebaseUserService = firebaseUserService
        self.authPassed = authPassed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Successfully LoginVC has been deinitialized!")
    }
}

//MARK: - ViewCycle
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView = SignUpView(authService: firebaseAuthService, userService:  firebaseUserService)

        view.handleKeyboardAdjustment(adjustmentFactor: 0.35)
        setupTFValidate()

        setupUI()
        setUpKeychain()
        bindImagePicker()
    }
}

//MARK: - SetupUI
private extension LoginViewController {
    
    func setupUI() {

        view
            .withBackgroundColor(UIColor(hexCode: "CBEDC4"))
            .withBackgroundImage(
                named: "background",
                at: CGPoint(x: view.bounds.midX, y: view.bounds.midY/1.25),
                size: CGSize(width: view.bounds.width, height: view.bounds.height)
            )
            .addSubviews(emailTextField,titleLabel,passwordTextField,loginButton,signUpButton,findPasswordButton,buttonStack)

        buttonStack
            .withArrangedSubviews(signUpButton,findPasswordButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        titleLabel
            .positionCenterX()
            .positionMultipleY(multiplier: 0.53)
        
        emailTextField
            .positionCenterX()
            .positionMultipleY(multiplier: 1.2)
            .withSize(250, 40)
    
        passwordTextField
            .putBelow(emailTextField, 20)
            .positionCenterX()
            .withSize(250, 40)
        
        loginButton
            .putBelow(passwordTextField, 20)
            .positionCenterX()
            .withSize(150, 40)
        
        buttonStack
            .putBelow(loginButton, 20)
            .positionMultipleX(multiplier: 0.5)
    }
}



//MARK: - Button Action
private extension LoginViewController {

    @objc func loginButtonTapped() {
        handleTextFormatError()
        handleKeychain()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        
        Task {
            do {
                try await firebaseAuthService.signInUser(email: email, password: password)
                print("Successfully \(#function)")
                enterMainView()
            } catch {
                print("Login error: \(error)")
            }
        }
    }
    
    func enterMainView() {
        authPassed()
    }
    
    @objc func signUpButtonTapped() {
        handleAuthenticationView()
    }
    
    @objc func findPasswordButtonTapped() {
        handleResetPasswordView()
    }
}

//MARK: - Present/Deinit AuthView
private extension LoginViewController {
    
    func handleAuthenticationView() {
        setupAuthView()
        view.addSubview(shadowContainer)
        shadowContainer.addSubview(authView)
        
        cancelAuthView()

        succesPhoneAuth()



    }

    func setupAuthView() {
        shadowContainer
            .withSize(widthRatioOfSuperview: 0.8)
            .withSize(heightOfSuperview: 0.5)
            .positionCenterY()
            .positionCenterX()

        authView
            .withCornerRadius(20)
            .putFullScreen()
        
    }

    func cancelAuthView() {
        authView.deinitAuthView
            .subscribe(onNext: { [weak self, weak authView] in
                self?.shadowContainer.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
    
    
    func succesPhoneAuth() {
        authView.authenticationSuccessful
            .subscribe(onNext: { [weak self, weak authView] in
                self?.shadowContainer.removeFromSuperview()
                DispatchQueue.main.async {
                    self?.presentSignUpView()
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Handle Alert with Error case

extension LoginViewController {
    
    func showAlert(for error: AppError) {
        let alertPresenter = alertHandler.generateAlert(for: error)
        alertPresenter(self)
    }

    //MARK: TextFormat Error
    func handleTextFormatError() {
        if !emailTextField.validationHandler!.isValidEmail(emailTextField.text) {
            showAlert(for: .formatError("잘못됫 이메일 형식입니다"))
        } else if !passwordTextField.validationHandler!.isValidPassWord(passwordTextField.text) {
            showAlert(for: .formatError("패스워드는 6글자 이상입니다"))
        }
    }
}


//MARK: - handle SignUpView
extension LoginViewController {
    
    func handlesSignupView() {
        presentSignUpView()
    }
    
    
    func presentSignUpView() {
        shadowContainer.withSize(widthRatioOfSuperview: 0.8)
        shadowContainer.withSize(heightOfSuperview: 0.7)
        
        view.addSubview(shadowContainer)
        shadowContainer.addSubview(signUpView!)
        bindSignUpAuthSuccess()

    }
    
    func bindSignUpAuthSuccess() {
        signUpView?.signUpAuthSuccessful
            .subscribe(onNext: { [weak self] in
                self?.shadowContainer.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }



}

//MARK: - handleResetPasswordView
extension LoginViewController {
    
    func handleResetPasswordView() {
        setUpResetPasswordView()
        view.addSubview(resetPasswordView)
        deinitResetPasswordView()
    }
    
    func setUpResetPasswordView() {
        resetPasswordView
            .positionCenterY()
            .positionCenterX()
            .withSize(widthRatioOfSuperview: 0.8)
            .withSize(heightOfSuperview: 0.4)
            .withCornerRadius(20)
            .withBlurEffect()
        
        
        resetPasswordView.resetEmailSent
            .subscribe(onNext: { [weak self, weak resetPasswordView] in
                self?.showResetEmailSentAlert()
                self?.resetPasswordView.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
        
    func showResetEmailSentAlert() {
        let alertController = UIAlertController(title: "Success", message: "A password reset email has been sent!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func deinitResetPasswordView() {
        resetPasswordView.deinitResetPasswordView
            .subscribe(onNext: { [weak self, weak resetPasswordView] in
                self?.resetPasswordView.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
}




//MARK: - Setup Keychain
extension LoginViewController {
    
    func handleKeychain() {
        
        let email = emailTextField.text ?? ""
        let success = KeychainManager.deleteAllItems()
        
        if success {
            print("All items deleted successfully")
        } else {
            print("Failed to delete item")
        }
        
        if KeychainManager.saveEmail(email: email) {
            print("Successfully saved email")
        } else {
            print("Failed to save email")
        }
        
    }
    
    
    func setUpKeychain() {
        if let email = KeychainManager.retrieveEmail() {
            emailTextField.text = email
            emailTextSubject.onNext(email)
            emailTextField.validationHandler?.textSubject.onNext(email)
        }
        KeychainManager.printAllKeychainItems()
    }
    
}

//MARK: - isValid TextField Format
extension LoginViewController {
    func setupTFValidate() {
        emailTextField
            .setupForValidation(type: .email)
        
        passwordTextField
            .setupForValidation(type: .password)
        
        setupLoginButtonValidate()
    }
    
    func setupLoginButtonValidate() {
        Observable.combineLatest(
            emailTextField.validationHandler!.isValidRelay,
            passwordTextField.validationHandler!.isValidRelay
        ) { emailIsValid, passwordIsValid in
            return emailIsValid && passwordIsValid
        }
        .subscribe(onNext: { [weak self] isEnabled in
            print("Received a new isValid value: \(isEnabled)")

            DispatchQueue.main.async {
                if isEnabled {
                    self?.loginButton.layer.borderColor = UIColor(hexCode: "68B984").cgColor
                } else {
                    self?.loginButton.layer.borderColor = UIColor(hexCode: "6C5F5B").cgColor
                }
            }
        })
        .disposed(by: disposeBag)
    }
}

//MARK: - PHPickerVC
extension LoginViewController: PHPickerViewControllerDelegate {
    
    func bindImagePicker() {
        signUpView?.didRequestImagePicker
            .subscribe(onNext: { [weak self] in
                self?.presentPHImagePicker()
            })
            .disposed(by: disposeBag)
    }
    
    func presentPHImagePicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
            picker.dismiss(animated: true)
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error loading image: \(error)")
                }
                if let image = image as? UIImage {
                    self?.signUpView?.profileRiveAnimationView.removeFromSuperview()
                    self?.signUpView?.profileImageButton.setImage(image, for: .normal)
                    
                    if let imageURL = self?.saveImageToTempDirectory(image) {
                        self?.signUpView?.profileImageURL.onNext(imageURL)
                    }
                }
                picker.dismiss(animated: true)
            }
        }
    }
    
    
    func saveImageToTempDirectory(_ image: UIImage) -> URL? {
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let imageName = UUID().uuidString
        let fileURL = tempDirectoryURL.appendingPathComponent(imageName).appendingPathExtension("png")
        
        do {
            if let pngData = image.pngData() {
                try pngData.write(to: fileURL, options: .atomicWrite)
                return fileURL
            }
        } catch {
            print("Failed to save image to temp directory:", error)
        }
        return nil
    }

}

class ShadowContainer: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.withShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.withShadow()
    }
}
