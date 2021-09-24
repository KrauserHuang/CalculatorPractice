//
//  Style3Button.swift
//  CalculatorPractice
//
//  Created by Tai Chin Huang on 2021/9/24.
//

import UIKit

class Style3Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
//        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        setTitleColor(.white, for: .normal)
        backgroundColor = Colors.equalBackgroundBlue
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = Colors.borderGray.cgColor
    }
}
