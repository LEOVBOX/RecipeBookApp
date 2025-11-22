//
//  RecomendationAssembly.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import UIKit

class SavedRecipesScreenAssembly {
    static func build() -> UIViewController {
        let router = SavedRecipesScreenRouter()
        let repository = MealDBRepository(dependencies: .init(networkService: MealDBNetworkService.shared, storageManagerRecipe: AppAssembly.makeStorageManager(), storageManagerIngredient: AppAssembly.makeStorageManager()))
        let interactor = SavedRecipesScreenInteractor(depenedencies: .init(recipesRepository: repository))
        let presenter = SavedRecipesScreenPresenter(dependencies: .init(interactor: interactor, router: router))
        let view = RecipeCollectionView(dependencies: .init(presenter: presenter, downloadable: false, cell: RecipeViewCell.self))
        let viewController = SavedRecipesScreenViewController(dependencies: .init(view: view, presenter: presenter))
        
        router.rootViewController = viewController
        
        presenter.attachView(view: view, controller: viewController)
        
        return viewController
    }
}
