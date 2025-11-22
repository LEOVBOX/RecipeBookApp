//
//  NoConnectionView.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 22.11.2025.
//

import UIKit

final class NoConnectionView: UIView {

    let retryButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "No Internet Connection"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center

        retryButton.setTitle("Retry", for: .normal)

        let stack = UIStackView(arrangedSubviews: [label, retryButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}
