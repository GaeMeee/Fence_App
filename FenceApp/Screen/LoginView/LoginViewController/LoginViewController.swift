
//MARK: - Module
import UIKit
import SnapKit
import RiveRuntime
import FirebaseAuth
import AuthenticationServices


//MARK: - Properties & Deinit
final class LoginViewController: UIViewController {
    
    //0. Title Label
    private lazy var titleLabel = UILabel()
        .withText("찾아줄개")
        .withFont(40)
        .withFontWeight(.bold)
        .withTextColor(UIColor(hexCode: "524A4E"))
        .withShadow()
    
    //1. Background animation
    private var viewModel = RiveViewModel(fileName: "background")
    private lazy var riveView = RiveView()
        .withBlurEffect()
        .withViewModel(viewModel)
    
    //2. TextField for Login
    private lazy var emailTextField = UITextField()
        .withPlaceholder("    Email")
        .withBlurEffect()
        .withBorder(color: UIColor(hexCode: "524A4E", alpha: 0.8), width: 2)
        .withCornerRadius(20)
    
    
    private lazy var passwordTextField = UITextField()
        .withPlaceholder("    Password")
        .secured()
        .withBlurEffect()
        .withBorder(color: UIColor(hexCode: "524A4E", alpha: 0.8), width: 2)
        .withCornerRadius(20)
    
    
    //3. Button for Login
    private lazy var loginButton = UIButton()
        .withTitle("Login")
        .withTextColor(.black)
        .withTarget(self, action: #selector(loginButtonTapped))
        .withBlurEffect()
        .withCornerRadius(20)
        .withBorder(color: UIColor(hexCode: "524A4E", alpha: 0.8), width: 2)
    
    private lazy var signUpButton = UIButton()
        .withTitle("Sign Up")
        .withTextColor(.black)
        .withTarget(self, action: #selector(showRegistrationPopUp))
    
    
    //4. Keyboard Handling
    private var emailTextFieldCenterYConstraint: Constraint?
    
    //6. UserInfoService
    private let userInfoService = UserInfoService()
    
    
    
    private lazy var allUIElements: [UIView] = [titleLabel,emailTextField, passwordTextField, loginButton, signUpButton]
    
    
    
    deinit {
        print("Successfully LoginVC has been deinitialized!")
    }
}


//MARK: - ViewCycle
extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        recognizeTapGesture()
        addNotificationObserver()
    }
}


//MARK: - SetupUI
private extension LoginViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        view.withBackgroundImage(named: "Spline", at: CGPoint(x: 1.8, y: 1.8), size: CGSize(width: 700, height: 1000))
        view.addSubviews(riveView,emailTextField,titleLabel,passwordTextField,loginButton,signUpButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        riveView.fullScreen()
        
        emailTextField
            .centerX()
            .size(250, 40)
        
        titleLabel
            .centerX()
            .above(emailTextField, 50)
        
        passwordTextField
            .below(emailTextField, 20)
            .centerX()
            .size(250, 40)
        
        loginButton
            .below(passwordTextField, 20)
            .centerX()
            .size(150, 40)
        
        signUpButton
            .below(loginButton, 10)
            .centerX()
            .size(150, 40)
    }
}


//MARK: - Button Action
private extension LoginViewController {
    
    @objc func loginButtonTapped() async {
        guard hasValidInput else { showAlertButton(); return }
        await authenticateUser()
    }
    
    
    @objc func showRegistrationPopUp() {
        
        allUIElements.forEach { $0.isHidden = true }
        
        let popUp = SignUpView()
        view.addSubview(popUp)
        popUp.alpha = 0.0
        popUp
            .centerX()
            .centerY()
            .size(200, 200)
        UIView.animate(withDuration: 0.3) {
            popUp.alpha = 1.0
        }
        
    }
}


//MARK: - Authenticate User
private extension LoginViewController {
    
    var hasValidInput: Bool {return !(emailTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)}
    
    func authenticateUser() async {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = result.user
            userInfoService.writeUserInfoToFirestore(email: user.email ?? "", uid: user.uid)
            print("Successfully \(#function)")
        } catch {
            showAlertButton()
            print("Failed to \(#function)")
        }
        assignRootView()
    }
}

//MARK: - Assign tabBarController as rootView
private extension LoginViewController {
    func assignRootView() {
        print("Move to MainVC")
        }
    
}


//MARK: - Alert
private extension LoginViewController {
    func showAlertButton() {
        Alert.show(on: self,
                   title: "Alert Title",
                   message: "This is an alert with a blurred background.",
                   actions: [
                    AlertAction(title: "Cancel", style: .cancel, handler: nil),
                    AlertAction(title: "OK", style: .default, handler: {
                        print("OK pressed")
                    })
                   ]
        )
    }
}


//MARK: - Keyboard Handling
private extension LoginViewController {
    
    
    func recognizeTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    func addNotificationObserver() {
        emailTextFieldCenterYConstraint = emailTextField.yConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        print("Succefully \(#function)")
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            emailTextFieldCenterYConstraint?.update(offset: -keyboardHeight/2)
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        emailTextFieldCenterYConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}


