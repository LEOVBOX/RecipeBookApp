//
//  IngredientsCollectionView.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 20.11.2025.
//

import UIKit

protocol IIngredientsCollectionView: UIView, AnyObject {
    func configure(recipes: [RecipeViewModel.IngredientViewModel])
}

final class IngredientsCollectionView: UIView {
    private enum Constants {
        static let backgroundColor: UIColor = .systemBackground
        static let itemsPerRow: CGFloat = 4
        static let spacing: CGFloat = 12
        static let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    private var recipes: [RecipeViewModel.IngredientViewModel] = []
    private var downloadable: Bool = true
    private var cell: IIngredientsViewCell.Type
    
    var onRecipeTapped: ((String) -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.spacing
        layout.minimumLineSpacing = Constants.spacing
        layout.sectionInset = Constants.sectionInsets
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = false
        collection.register(DownloadableIngredientViewCell.self, forCellWithReuseIdentifier: DownloadableIngredientViewCell.identifier)
        return collection
    }()
    
    struct Dependencies {
        let cell: IIngredientsViewCell.Type
        let downloadable: Bool
        let scrollable: Bool
    }
    
    init(dependencies: Dependencies) {
        self.downloadable = dependencies.downloadable
        self.cell = dependencies.cell
        super.init(frame: .zero)
        setupUI()
        setupCollectionView()
        collectionView.isScrollEnabled = dependencies.scrollable
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        collectionViewHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint.isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell.self, forCellWithReuseIdentifier: cell.identifier)
    }
    
    private func calculateCollectionViewHeight() -> CGFloat {
        guard !recipes.isEmpty else { return 0 }
        
        let itemsCount = CGFloat(recipes.count)
        let rowsCount = ceil(itemsCount / Constants.itemsPerRow)
        
        // Высота одной ячейки (можете настроить под ваш дизайн)
        let cellHeight: CGFloat = 120 // Высота ячейки
        let totalCellsHeight = rowsCount * cellHeight
        let totalSpacingHeight = (rowsCount - 1) * Constants.spacing
        let sectionInsetsHeight = Constants.sectionInsets.top + Constants.sectionInsets.bottom
        
        return totalCellsHeight + totalSpacingHeight + sectionInsetsHeight
    }
    
    private func updateHeight() {
        let newHeight = calculateCollectionViewHeight()
        collectionViewHeightConstraint.constant = newHeight
        
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
        
        self.superview?.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // При изменении размера пересчитываем layout
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDataSource
extension IngredientsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DownloadableIngredientViewCell.identifier,
            for: indexPath
        ) as? DownloadableIngredientViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: recipes[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension IngredientsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let totalSpacing = (Constants.itemsPerRow - 1) * Constants.spacing +
                          Constants.sectionInsets.left + Constants.sectionInsets.right
        let availableWidth = collectionView.bounds.width - totalSpacing
        let widthPerItem = availableWidth / Constants.itemsPerRow
        
        // Высота ячейки (можете настроить под ваш дизайн)
        let height: CGFloat = 120
        
        return CGSize(width: widthPerItem, height: height)
    }
}

// MARK: - IIngredientsCollectionView
extension IngredientsCollectionView: IIngredientsCollectionView {
    func configure(recipes: [RecipeViewModel.IngredientViewModel]) {
        self.recipes = recipes
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.updateHeight()
        }
    }
}
