//
//  DownloadableIngredientViewCell.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 20.11.2025.
//

import UIKit

final class DownloadableIngredientViewCell: UICollectionViewCell, IIngredientsViewCell{
    static let identifier = String(describing: DownloadableIngredientViewCell.self)
    
    private enum Constants {
        static let stackSpacing: CGFloat = 4
        static let titleFont: UIFont = .systemFont(ofSize: 13, weight: .semibold)
        static let cornerRadius: CGFloat = 8
        static let titleLabelNumberOfLines: Int = 1
    }
    
    private lazy var imageView: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.setCornerRadius(Constants.cornerRadius)
        imageView.setContentMode(.scaleAspectFit)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = Constants.titleLabelNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var measureLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, measureLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleStackView])
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
    
    func configure(with viewModel: RecipeViewModel.IngredientViewModel) {
        titleLabel.text = viewModel.name
        measureLabel.text = viewModel.measurement
        if let imageURL = viewModel.imageURL {
            imageView.setImage(with: URL(string: imageURL))
        }
        else {
            imageView.setImage(with: nil)
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        measureLabel.text = nil
        imageView.clearImage()
    }
}
