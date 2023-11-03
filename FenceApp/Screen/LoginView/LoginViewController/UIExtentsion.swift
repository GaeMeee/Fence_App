import UIKit
import SnapKit
import RiveRuntime



// MARK: - UIView Extensions
extension UIView {
    
    // MARK: Positioning
    @discardableResult
    func positionCenterX() -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints { $0.centerX.equalTo(superview) }
        return self
    }
    
    @discardableResult
    func positionCenterY() -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints { $0.centerY.equalTo(superview) }
        return self
    }
    
    
    @discardableResult
    func positionMultipleX(multiplier: CGFloat) -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints {
            $0.centerX.equalTo(superview.snp.centerX).offset(superview.frame.width * multiplier - superview.frame.width / 2)
        }
        return self
    }
    
    @discardableResult
    func positionMultipleY(multiplier: CGFloat) -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints {
            $0.centerY.equalTo(superview.snp.centerY).multipliedBy(multiplier)
        }
        return self
    }
    
    //for keyboard handling
    @discardableResult
    func positionMultipleY(multiplier: CGFloat, constraint: inout Constraint?) -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints { make in
            constraint = make.centerY.equalTo(superview.snp.centerY).multipliedBy(multiplier).constraint
        }
        return self
    }
    
    
    @discardableResult
    func putBelow(_ view: UIView, _ offset: CGFloat) -> Self {
        snp.makeConstraints { $0.top.equalTo(view.snp.bottom).offset(offset) }
        return self
    }
    
    @discardableResult
    func putAbove(_ view: UIView, _ offset: CGFloat) -> Self {
        snp.makeConstraints { $0.bottom.equalTo(view.snp.top).offset(-offset) }
        return self
    }
    
    func putFullScreen() {
        guard let superview = self.superview else { return }
        snp.makeConstraints { $0.edges.equalTo(superview) }
    }
    
    @discardableResult
    func positionCenter() -> Self {
        guard let superview = self.superview else { return self }
        
        snp.makeConstraints {
            $0.center.equalTo(superview)
        }
        return self
    }
    
    // MARK: Sizing
    @discardableResult
    func withSize(_ width: CGFloat, _ height: CGFloat) -> Self {
        snp.makeConstraints { $0.width.equalTo(width); $0.height.equalTo(height) }
        return self
    }
    
    @discardableResult
    func withSize(aspectRatioOfSuperview ratio: CGFloat) -> Self {
        guard let superview = self.superview else { return self }
        
        snp.makeConstraints {
            $0.width.equalTo(superview.snp.width).multipliedBy(ratio)
            $0.height.equalTo(superview.snp.height).multipliedBy(ratio)
        }
        return self
    }
    
    @discardableResult
    func withSize(widthRatioOfSuperview ratio: CGFloat) -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints {
            $0.width.equalTo(superview.snp.width).multipliedBy(ratio)
        }
        return self
    }
    
    @discardableResult
    func withSize(heightOfSuperview ratio: CGFloat) -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints {
            $0.height.equalTo(superview.snp.height).multipliedBy(ratio)
        }
        return self
    }
    
    @discardableResult
    func withHeight(_ height: CGFloat) -> Self {
        snp.makeConstraints { $0.height.equalTo(height) }
        return self
    }
    
    // MARK: Styling
    
    @discardableResult
    func withShadow(color: UIColor = .black,
                    opacity: Float = 1.0,
                    offset: CGSize = CGSize(width: 0, height: 3),
                    radius: CGFloat = 10) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func withBackgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    
    @discardableResult
    func withBottomBorder(color: UIColor? = .black, width: CGFloat) -> Self {
        
        let bottomBorder = CALayer()
        bottomBorder.name = "bottomBorder"
        bottomBorder.backgroundColor = color?.cgColor
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        layer.addSublayer(bottomBorder)
        self.layoutIfNeeded()
        return self
    }
    
    func updateBottomBorder(color: UIColor? = .black, width: CGFloat) -> Self {
        if let bottomBorder = layer.sublayers?.first(where: { $0.name == "bottomBorder" }) {
            bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
            bottomBorder.backgroundColor = color?.cgColor
        }
        return self
    }

    
    @discardableResult
    func withShadowContainer(color: UIColor = .black, opacity: Float = 0.5, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) -> UIView {
        
        guard let superview = self.superview else { return self }
        
        let shadowContainerView = UIView()
        shadowContainerView.backgroundColor = .clear
        shadowContainerView.layer.shadowColor = color.cgColor
        shadowContainerView.layer.shadowOpacity = opacity
        shadowContainerView.layer.shadowOffset = offset
        shadowContainerView.layer.shadowRadius = radius
        
        superview.addSubview(shadowContainerView)
        shadowContainerView.snp.makeConstraints { $0.edges.equalTo(self) }
        
        shadowContainerView.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalTo(shadowContainerView) }
        isUserInteractionEnabled = true
        
        return shadowContainerView
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
        layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func withBlurEffect() -> Self {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.masksToBounds = true
        blurEffectView.isUserInteractionEnabled = false
        self.insertSubview(blurEffectView, at: 0)
        return self
    }
    
    @discardableResult
    func withRiveAnimation(using viewModel: RiveViewModel) -> Self {
        let riveView = RiveView().withViewModel(viewModel)
        addSubview(riveView)
        riveView.snp.makeConstraints { $0.edges.equalTo(self) }
        insertSubview(riveView, at: 0)
        isUserInteractionEnabled = false
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
        
        if let superview = self.superview {
            snp.makeConstraints {
                constraint = $0.centerY.equalTo(superview).constraint
            }
        } else {
            snp.makeConstraints {
                constraint = $0.centerY.equalTo(self).constraint
            }
        }
        
        return constraint!
    }
    
    
}

// MARK: - UIButton Extensions
extension UIButton {
    
    
    @discardableResult
    func withFont(size: CGFloat, fontName: String? = nil) -> Self {
        if let fontName = fontName, let customFont = UIFont(name: fontName, size: size) {
            titleLabel?.font = customFont
        } else {
            titleLabel?.font = UIFont.systemFont(ofSize: size)
        }
        setNeedsLayout()
        return self
    }
    
    
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
    func withSFImage(systemName: String, pointSize: CGFloat? = nil, weight: UIImage.SymbolWeight = .regular, tintColor: UIColor? = nil, for state: UIControl.State = .normal) -> Self {
        
        var image: UIImage?
        
        if let pointSize = pointSize {
            let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
            image = UIImage(systemName: systemName, withConfiguration: configuration)
        } else {
            image = UIImage(systemName: systemName)
        }
        
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        
        setImage(image, for: state)
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
        func withText(_ text: String) -> UITextField {
            self.text = text
            return self
        }
    

    @discardableResult
    func withSecured() -> Self {
        isSecureTextEntry = true
        return self
    }
    
    
    @discardableResult
    func withTFBottomBorder(color: UIColor, width: CGFloat) -> Self {
        self.borderStyle = .none
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        return self
    }

    
    @discardableResult
    func withInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
        
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

// MARK: - UIStackView Extensions
extension UIStackView {
    
    @discardableResult
    func withArrangedSubviews(_ views: UIView...) -> Self {        for view in views {
        addArrangedSubview(view)
    }
        return self
    }
    
    @discardableResult
    func withAxis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }
    
    @discardableResult
    func withDistribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    
    @discardableResult
    func withAlignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
    
    @discardableResult
    func withSpacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
    
    @discardableResult
    func withMargins(_ margins: UIEdgeInsets) -> Self {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = margins
        return self
    }
    
    
}


//MARK: - UIImageView extension

extension UIImageView {
    
    @discardableResult
    func withImage(_ named: String) -> Self {
        self.image = UIImage(named: named)
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


//MARK: - RiveView extension
extension RiveView {
    func withViewModel(_ viewModel: RiveViewModel) -> RiveView {
        isUserInteractionEnabled = false
        viewModel.setView(self)
        return self
    }
}

