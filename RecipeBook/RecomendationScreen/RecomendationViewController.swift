//
//  RecomendationViewController.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import UIKit

protocol IRecomendationViewController: AnyObject {
    
}

final class RecomendationViewController: UIViewController, IRecomendationViewController {
    private let contentView: IRecipeCollectionView
    private let presenter: IRecomendationPresenter
    private lazy var noConnectionView = NoConnectionView()
    
    struct Dependencies {
        let view: IRecipeCollectionView
        let presenter: IRecomendationPresenter
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
        title = "Recomendations"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}
