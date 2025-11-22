//
//  RecipeView.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 20.11.2025.
//

import UIKit

protocol IRecipeView: UIView, AnyObject {
    func configure(with viewModel: RecipeViewModel)
}

final class DownloadableRecipeView: UIView {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let padding: CGFloat = 8
        static let instructionsFont: UIFont = .systemFont(ofSize: 18, weight: .regular)
        static let titleFont: UIFont = .systemFont(ofSize: 30, weight: .bold)
    }
    
    private let presenter: IRecipeScreenPresenter
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    private lazy var imageView: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.setCornerRadius(Constants.cornerRadius)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ingredientsView: IngredientsCollectionView = {
        let ingredientsCollectionView = IngredientsCollectionView(dependencies: .init(cell: DownloadableIngredientViewCell.self, downloadable: true, scrollable: false))
        ingredientsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return ingredientsCollectionView
    }()
    
    private lazy var descriptionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.instructionsFont
        label.numberOfLines = 0
        return label
    }()
    
    struct Dependencies {
        let presenter: IRecipeScreenPresenter
    }
    
    init(dependencies: Dependencies) {
        self.presenter = dependencies.presenter
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DownloadableRecipeView {
    func setupUI() {
        setupBackground()
        
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(descriptionStack)
        scrollView.addSubview(ingredientsView)
        scrollView.addSubview(instructionsLabel)
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Constants.padding),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Constants.padding),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Constants.padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            descriptionStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.padding),
            descriptionStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Constants.padding),
            descriptionStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Constants.padding),

            ingredientsView.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor, constant: 16),
            ingredientsView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            ingredientsView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

            ingredientsView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            instructionsLabel.topAnchor.constraint(equalTo: ingredientsView.bottomAnchor, constant: Constants.padding),
            instructionsLabel.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Constants.padding),
            instructionsLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Constants.padding),
            instructionsLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Constants.padding)
        ])
    }

}

extension DownloadableRecipeView: IRecipeView {
    func configure(with viewModel: RecipeViewModel) {
        titleLabel.text = viewModel.title
        if let imageURL = viewModel.imageURL {
            imageView.setImage(with: URL(string: imageURL))
        }
        else {
            imageView.setImage(with: nil)
        }
        
        ingredientsView.configure(recipes: viewModel.ingredients)
        instructionsLabel.text = viewModel.instructions
    }
}
