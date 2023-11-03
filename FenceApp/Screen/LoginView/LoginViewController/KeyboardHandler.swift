
import RxSwift
import UIKit
import RxKeyboard


struct KeyboardHandler {
    let disposeBag = DisposeBag()

    func adjustViewForKeyboard(view: UIView, adjustmentFactor: CGFloat = 0.5) {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak view] keyboardHeight in
                view?.transform = .identity
                if keyboardHeight > 0 {
                    view?.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight * adjustmentFactor)
                }
            })
            .disposed(by: disposeBag)
    }

}
extension UIView {
    private struct AssociatedKeys {
        static var keyboardHandlerKey = "keyboardHandlerKey"
    }

    private var keyboardHandler: KeyboardHandler? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.keyboardHandlerKey) as? KeyboardHandler
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.keyboardHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func handleKeyboardAdjustment(adjustmentFactor: CGFloat = 0.5) -> Self {
        if keyboardHandler == nil {
            keyboardHandler = KeyboardHandler()
        }
        keyboardHandler?.adjustViewForKeyboard(view: self, adjustmentFactor: adjustmentFactor)
        setupTapToDismissKeyboard()
        
        return self
    }

    func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }

}
