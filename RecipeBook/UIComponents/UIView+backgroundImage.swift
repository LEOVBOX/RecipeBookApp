//
//  UIView+backgroundImage.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 22.11.2025.
//

import UIKit

extension UIView {
    func setupBackground() {
        var backgrounView: UIImageView?
        if let backgroundImage = AppAssembly.getBackgroundImgae() {
            backgrounView = UIImageView(image: backgroundImage)
            if let backgrounView {
                addSubview(backgrounView)
                
                NSLayoutConstraint.activate([
                    backgrounView.topAnchor.constraint(equalTo: topAnchor),
                    backgrounView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    backgrounView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    backgrounView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
            }
        }
    }
    
}
