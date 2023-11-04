

import UIKit


class ColorHandler {
    static let shared = ColorHandler()
    
    let titleColor: UIColor
    let textColor: UIColor
    let buttonTextColor: UIColor
    let buttonActivatedColor: UIColor
    let buttonDeactivateColor: UIColor
    
    
    private init() {
        titleColor = UIColor(hexCode: "55BCEF")
        textColor =  UIColor(hexCode: "55BCEF")
        buttonTextColor = .white
        buttonActivatedColor = UIColor(hexCode: "55BCEF")
        buttonDeactivateColor = UIColor(hexCode: "A9A9A9")
    }
}

