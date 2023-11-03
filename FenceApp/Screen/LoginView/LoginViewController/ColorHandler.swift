//
//  Color.swift
//  FenceApp
//
//  Created by ㅣ on 2023/11/03.
//

import UIKit


class ColorHandler {
    static let shared = ColorHandler()
    
    let titleColor: UIColor
    let textColor: UIColor
    let buttonTextColor: UIColor
    let buttonActivatedColor: UIColor
    let buttonDeactivateColor: UIColor
    
    
    private init() {
        titleColor = .black
        textColor = UIColor(hexCode: "444941")
        buttonTextColor = .white
        buttonActivatedColor = UIColor(hexCode: "68B984")
        buttonDeactivateColor = UIColor(hexCode: "A6A9B6")
    }
}
