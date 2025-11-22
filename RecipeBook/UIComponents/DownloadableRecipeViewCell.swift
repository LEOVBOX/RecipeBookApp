//
//  RecipeViewCell.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import UIKit

final class DownloadableRecipeViewCell: UICollectionViewCell, IRecipeViewCell {
    static let identifier = String(describing: DownloadableRecipeViewCell.self)
    
    private enum Constants {
        static let stackSpacing: CGFloat = 4
        static let titleFont: UIFont = .systemFont(ofSize: 14, weight: .semibold)
        static let cornerRadius: CGFloat = 8
        static let titleLabelNumberOfLines: Int = 2
    }
    
    private lazy var imageView: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.setCornerRadius(Constants.cornerRadius)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textAlignment = .left
        label.numberOfLines = Constants.titleLabelNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    func configure(name: String, imageURL: String?) {
        titleLabel.text = name
        if let imageURL = imageURL {
            imageView.setImage(with: URL(string: imageURL))
        }
        else {
            imageView.setImage(with: nil)
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imageView.clearImage()
    }
}
