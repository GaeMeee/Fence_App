import UIKit

struct AlertAction {
    var title: String
    var style: UIAlertAction.Style
    var handler: (() -> Void)?
}
struct Alert {

    static func show(on viewController: UIViewController,
                     title: String?,
                     message: String?,
                     actions: [AlertAction]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: { _ in
                action.handler?()
            })
            alertController.addAction(alertAction)
        }
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
