//
//  RecomendationViewController.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import UIKit

protocol ISavedRecipesViewController: AnyObject {
    
}

final class SavedRecipesScreenViewController: UIViewController, ISavedRecipesViewController {
    private let contentView: IRecipeCollectionView
    private let presenter: ISavedRecipesScreenPresenter
    
    struct Dependencies {
        let view: IRecipeCollectionView
        let presenter: ISavedRecipesScreenPresenter
    }
    
    init(dependencies: Dependencies) {
        self.contentView = dependencies.view
        self.presenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
        contentView.onRecipeTapped = { [weak self] meal in
            self?.presenter.didSelectMeal(with: meal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}
