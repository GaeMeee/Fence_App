import UIKit
import SnapKit
import RiveRuntime
import FirebaseAuth



// MARK: - UIView Extensions
extension UIView {
    
    // MARK: Positioning
    @discardableResult
    func centerX() -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints { $0.centerX.equalTo(superview) }
        return self
    }
    
    @discardableResult
    func centerY() -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints { $0.centerY.equalTo(superview) }
        return self
    }

    
    @discardableResult
    func below(_ view: UIView, _ offset: CGFloat) -> Self {
        snp.makeConstraints { $0.top.equalTo(view.snp.bottom).offset(offset) }
        return self
    }
    
    @discardableResult
    func above(_ view: UIView, _ offset: CGFloat) -> Self {
        snp.makeConstraints { $0.bottom.equalTo(view.snp.top).offset(-offset) }
        return self
    }
    
    
    func fullScreen() {
        guard let superview = self.superview else { return }
        snp.makeConstraints { $0.edges.equalTo(superview) }
    }
    
    
    // MARK: Sizing
    @discardableResult
    func size(_ width: CGFloat, _ height: CGFloat) -> Self {
        snp.makeConstraints { $0.width.equalTo(width); $0.height.equalTo(height) }
        return self
    }
    
    // MARK: Styling
    @discardableResult
    func withBlurEffect() -> Self {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = false
        insertSubview(blurEffectView, at: 0)
        return self
    }

    @discardableResult
    func withBorder(color: UIColor, width: CGFloat) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        return self
    }
    
    @discardableResult
    func withCornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        clipsToBounds = true
        return self
    }
    
    @discardableResult
    func withShadow(color: UIColor = .black, opacity: Float = 0.2, offset: CGSize = CGSize(width: 0, height: 3), radius: CGFloat = 1.0) -> Self {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        return self
    }

    //MARK: Others
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    @discardableResult
    func withBackgroundImage(named imageName: String, at position: CGPoint = .zero, size: CGSize? = nil) -> Self {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        insertSubview(imageView, at: 0)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalTo(snp.leading).inset(position.x)
            $0.centerY.equalTo(snp.top).inset(position.y)
            $0.size.equalTo(size ?? 0)
        }
        return self
    }
    
    @discardableResult
    func yConstraints() -> Constraint {
        var constraint: Constraint?
        guard let superview = self.superview else { return constraint! }
        snp.makeConstraints {
            constraint = $0.centerY.equalTo(superview).constraint
        }
        return constraint!
    }

}

// MARK: - UIButton Extensions
extension UIButton {
    
    @discardableResult
    func withTitle(_ title: String) -> Self {
        setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    func withTextColor(_ color: UIColor) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }
    
    @discardableResult
    func withTarget(_ target: Any?, action: Selector) -> Self {
        addTarget(target, action: action, for: .touchUpInside)
        return self
    }
    
    @discardableResult
    func withBackgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
}

// MARK: - UITextField Extensions
extension UITextField {
    
    @discardableResult
    func withPlaceholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    @discardableResult
    func secured() -> Self {
        isSecureTextEntry = true
        return self
    }

}

// MARK: - UILabel Extensions
extension UILabel {
    
    @discardableResult
    func withText(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func withFont(_ size: CGFloat, fontName: String = "System") -> Self {
        if fontName == "System" {
            font = UIFont.systemFont(ofSize: size)
        } else {
            font = UIFont(name: fontName, size: size)
        }
        return self
    }

    @discardableResult
    func withFontWeight(_ weight: UIFont.Weight) -> Self {
        font = UIFont.systemFont(ofSize: font.pointSize, weight: weight)
        return self
    }
    
    @discardableResult
    func withTextColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
}


//MARK: - RiveView extension
extension RiveView {
    func withViewModel(_ viewModel: RiveViewModel) -> RiveView {
        isUserInteractionEnabled = false
        viewModel.setView(self)
        return self
    }
}


//MARK: - UIColor extension
extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
