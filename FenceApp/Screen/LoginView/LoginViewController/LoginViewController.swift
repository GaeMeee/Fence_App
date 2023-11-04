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
    
    private let authView = AuthenticationView()
    private var signUpView: SignUpView?
    private let resetPasswordView = ResetPasswordView()
    
    private var disposeBag = DisposeBag()
    private var emailTextSubject = BehaviorSubject<String?>(value: nil)
    let successAuthSubject = PublishSubject<Void>()
    
    
    private var shadowContainer = UIView()
        .withShadow()
    
    private lazy var titleLabel = UILabel()
        .withText("찾아줄개")
        .withFont(40, fontName: "Binggrae-Bold")
        .withTextColor(ColorHandler.shared.titleColor)
        .withBottomBorder(width: 3.0)
    
    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email@gmail.com")
        .withInsets(left: 5, right: 20)
        .withBottomBorder(width: 3.0)
    
    private let passwordTextField = UITextField()
        .withPlaceholder("비밀번호 6글자 이상")
        .withSecured()
        .withInsets(left: 5, right: 20)
    
    private lazy var loginButton = UIButton()
        .withTitle("로그인")
        .withTextColor(ColorHandler.shared.buttonTextColor)
        .withBackgroundColor(ColorHandler.shared.buttonActivatedColor)
        .withFont(size: 20)
        .withTarget(self, action: #selector(loginButtonTapped))
        .withCornerRadius(15)
    
    
    private lazy var signUpButton = UIButton()
        .withTitle("회원 가입")
        .withTextColor(ColorHandler.shared.textColor)
        .withFont(size: 20)
        .withTarget(self, action: #selector(signUpButtonTapped))
    
    private lazy var findPasswordButton = UIButton()
        .withTitle("비밀번호 찾기")
        .withTextColor(ColorHandler.shared.textColor)
        .withFont(size: 20)
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
        
        setupUI()
        setUpKeychain()
        bindImagePicker()
        
        emailTextField
            .setupForValidation(type: .email)
        
        passwordTextField
            .setupForValidation(type: .password)
        
        setupLoginButtonValidate()

    }
    
}

//MARK: - SetupUI
private extension LoginViewController {
    
    func setupUI() {
        
        view
            .handleKeyboardAdjustment(adjustmentFactor: 0.4)
            .withBackgroundColor(.white)
            .withBackgroundImage(
                named: "background",
                at: CGPoint(x: view.bounds.midX, y: view.bounds.midY/1.1),
                size: CGSize(width: view.bounds.width/0.75, height: view.bounds.height/0.3)
            )
            .addSubviews(emailTextField,titleLabel,passwordTextField,loginButton,signUpButton,findPasswordButton,buttonStack)
        
        buttonStack
            .withArrangedSubviews(signUpButton,findPasswordButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        titleLabel
            .positionCenterX()
            .positionMultipleY(multiplier: 0.47)
        
        emailTextField
            .positionCenterX()
            .positionMultipleY(multiplier: 1.3)
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
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Task {
            do {
                let authResult = try await firebaseAuthService.loginUser(email: email, password: password)
                print("Successfully logged in")
                await fetchAndStoreCurrentUser(identifier: authResult.user.uid)
                enterMainView()
            } catch {
                print("Login error: \(error)")
            }
        }
    }
    
    func fetchAndStoreCurrentUser(identifier: String) async {
        do {
            let user = try await firebaseUserService.fetchUser(userIdentifier: identifier)
            let fbUser = FBUser(email: user.email, profileImageURL: user.profileImageURL, identifier: user.identifier, nickname: user.nickname)
            CurrentUserInfo.shared.currentUser = fbUser
            print("Current User Info\(String(describing: CurrentUserInfo.shared.currentUser))")
        } catch {
            print("Failed to fetch user data: \(error)")
        }
    }
    
    
    //MARK: TextFormat Error
    func handleTextFormatError() {
        if !emailTextField.validationHandler!.isValidEmail(emailTextField.text) {
            AlertHandler.shared.presentErrorAlert(for: .formatError("잘못된 이메일 형식입니다"))
        } else if !passwordTextField.validationHandler!.isValidPassWord(passwordTextField.text) {
            AlertHandler.shared.presentErrorAlert(for: .formatError("패스워드는 6글자 이상입니다"))
        }
    }
    
    
    func enterMainView() {
        authPassed()
    }
    
    @objc func signUpButtonTapped() {
        handleAuthenticationView()
        handlesSignupView()
    }
    
    @objc func findPasswordButtonTapped() {
        
        handleResetPasswordView()
    }
}

//MARK: - Present/Deinit AuthView
private extension LoginViewController {
    
    func handleAuthenticationView() {
        setupAuthView()
        cancelAuthView()
        successPhoneAuth()
    }
    
    
    func setupAuthView() {

        view.addSubview(shadowContainer)
        shadowContainer.addSubview(authView)
        disableUIComponent()
        
        signUpButton.isUserInteractionEnabled = false
        findPasswordButton.isUserInteractionEnabled = false
        
        shadowContainer
            .withSize(widthRatioOfSuperview: 0.8)
            .withSize(heightOfSuperview: 0.45)
            .positionCenterY()
            .positionCenterX()
        
        authView
            .withCornerRadius(20)
            .putFullScreen()
    }
    
    func disableUIComponent() {
        signUpButton.isUserInteractionEnabled = false
        findPasswordButton.isUserInteractionEnabled = false
        loginButton.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
    }
    
    func enableUIComponent() {
        signUpButton.isUserInteractionEnabled = true
        findPasswordButton.isUserInteractionEnabled = true
        loginButton.isUserInteractionEnabled = true
        emailTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
    }
    
    func cancelAuthView() {
        authView.deinitAuthView
            .subscribe(onNext: { [weak self, weak authView] in
                self?.shadowContainer.removeFromSuperview()
                self?.authView.removeFromSuperview()
                self?.enableUIComponent()
            })
            .disposed(by: disposeBag)
    }
    
    
    func successPhoneAuth() {
        authView.authenticationSuccessful
            .subscribe(onNext: { [weak self] in
                self?.shadowContainer.removeFromSuperview()
                self?.authView.removeFromSuperview()
                self?.presentSignUpView()
            })
            .disposed(by: disposeBag)
    }
}



//MARK: - handle SignUpView
extension LoginViewController {
    
    func handlesSignupView() {
        successAuth()
        cancelSignupViewSubject()
    }
    
    func successAuth() {
        self.successAuthSubject
            .subscribe(onNext: { [weak self] in
                self?.presentSignUpView()
            })
            .disposed(by: disposeBag)
    }
    
    func presentSignUpView() {
        
        guard let signUpView = signUpView else { return }
        
        view.addSubview(shadowContainer)
        shadowContainer.addSubview(signUpView)
        disableUIComponent()
        
        shadowContainer
            .positionCenterX()
            .positionCenterY()
            .withSize(widthRatioOfSuperview: 0.8)
            .withSize(heightOfSuperview: 0.7)
        
        signUpView
            .withCornerRadius(20)
            .putFullScreen()
    }
    
    func cancelSignupViewSubject() {
        signUpView?.cancelSignupViewSubject
            .subscribe(onNext: {[weak self] in
                self?.shadowContainer.removeFromSuperview()
                self?.enableUIComponent()
            })
            .disposed(by: disposeBag)
    }
    
    
    func bindSignUpAuthSuccess() {
        signUpView?.signUpAuthSuccessful
            .subscribe(onNext: { [weak self] in
                self?.shadowContainer.removeFromSuperview()
                self?.signUpView?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - handleResetPasswordView
extension LoginViewController {
    
    func handleResetPasswordView() {
        setUpResetPasswordView()
        deinitResetPasswordView()
    }
    
    func setUpResetPasswordView() {
        
        view.addSubview(shadowContainer)
        shadowContainer.addSubviews(resetPasswordView)
        disableUIComponent()
        
        shadowContainer
            .positionCenterX()
            .positionCenterY()
            .withSize(widthRatioOfSuperview: 0.8)
            .withSize(heightOfSuperview: 0.4)
        
        resetPasswordView
            .withCornerRadius(20)
            .putFullScreen()
        
        resetPasswordView.resetEmailSent
            .subscribe(onNext: { [weak self, weak resetPasswordView] in
                AlertHandler.shared.presentSuccessAlert(for: .sendMessageSuccessful("이메일에서 비밀번호를 재설정해주세요"))
                self?.shadowContainer.removeFromSuperview()
                self?.enableUIComponent()
            })
            .disposed(by: disposeBag)
    }
    
    
    
    func deinitResetPasswordView() {
        resetPasswordView.deinitResetPasswordView
            .subscribe(onNext: { [weak self, weak resetPasswordView] in
                self?.shadowContainer.removeFromSuperview()
                self?.enableUIComponent()
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
    
    func setupLoginButtonValidate() {
        Observable
            .combineLatest(emailTextField.validationHandler!.isValidRelay,
                           passwordTextField.validationHandler!.isValidRelay) { isEmailValid, isPasswordValid in
                
                return isEmailValid && isPasswordValid
            }
                           .subscribe(onNext: { [weak self] isValid in
                               DispatchQueue.main.async {
                                   self?.loginButton.isEnabled = isValid
                                   let buttonColor = isValid ? ColorHandler.shared.buttonActivatedColor: ColorHandler.shared.buttonDeactivateColor
                                   self?.loginButton.backgroundColor = buttonColor
                                   self?.loginButton.isEnabled = isValid
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
                    AlertHandler.shared.presentErrorAlert(for: .loadImageError("이미지 불러오기에 실패했습니다"))}
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
