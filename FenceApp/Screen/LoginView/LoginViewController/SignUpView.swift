
import UIKit
final class SignUpView: UIView {
    
    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email")
        .withBlurEffect()
        .withBorder(color: UIColor(hexCode: "524A4E", alpha: 0.8), width: 2)
        .withCornerRadius(20)

    private lazy var profileImageView = UIImageView()
    private lazy var nicknameTextField = UITextField()
        

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.withShadow()
        self.addSubviews(emailTextField)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(emailTextField, profileImageView, nicknameTextField)

        emailTextField
            .centerX()
            .centerY()
    }
}
