//
//  Untitled.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import UIKit

protocol IRecipeCollectionView: UIView, AnyObject{
    var onRecipeTapped: ((String) -> Void)? { get set }
    func configure(recipes: [MealViewModel])
    func appendMeals(_ meals: [MealViewModel])
    func update()
}

final class RecipeCollectionView: UIView {
    private enum Constants {
        static let backgroundColor: UIColor = .systemBackground
    }
    
    private var downloadable: Bool
    private var recipes: [MealViewModel] = []
    private let presenter: IRecipeCollectionPresenter
    private let cell: IRecipeViewCell.Type
    
    var onRecipeTapped: ((String) -> Void)?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(environment.traitCollection.verticalSizeClass == .compact ? 0.3 : 0.5),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(environment.traitCollection.verticalSizeClass == .compact ? 0.66 : 0.25)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
            return section
        }
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = Constants.backgroundColor
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    struct Dependencies {
        let presenter: IRecipeCollectionPresenter
        let downloadable: Bool
        let cell: IRecipeViewCell.Type
    }
    
    init(dependencies: Dependencies) {
        self.presenter = dependencies.presenter
        self.downloadable = dependencies.downloadable
        self.cell = dependencies.cell
        super.init(frame: .zero)
        setupUI()
        setupCollectionView()
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
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell.self, forCellWithReuseIdentifier: cell.identifier)
    }
}

extension RecipeCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as? IRecipeViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(name: recipes[indexPath.item].name, imageURL: recipes[indexPath.item].imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onRecipeTapped?(recipes[indexPath.item].id)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard downloadable == true else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight * 2 {
            self.presenter.loadMoreMeals()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        let recipe = recipes[indexPath.item]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let info = UIAction(title: "Details", image: UIImage(systemName: "info")) { _ in
                self?.presenter.didSelectMeal(with: recipe.id)
            }
            
            if self?.downloadable == false {
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    self?.presenter.selectedCellAction(with: recipe.id)
                }
                return UIMenu(title: "", children: [info, delete])
            }
            
            return UIMenu(title: "", children: [info])
        }
    }
}

extension RecipeCollectionView: IRecipeCollectionView {
    func update() {
        presenter.viewDidLoad()
    }
    
    func appendMeals(_ newMeals: [MealViewModel]) {
        let startIndex = recipes.count
        let endIndex = startIndex + newMeals.count
        let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
        
        recipes.append(contentsOf: newMeals)
        
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: indexPaths)
        }
    }
    
    func configure(recipes: [MealViewModel]) {
        self.recipes = recipes
        collectionView.reloadData()
    }
}
