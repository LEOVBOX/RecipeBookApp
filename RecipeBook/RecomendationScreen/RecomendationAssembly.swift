//
//  RecomendationAssembly.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import UIKit

class RecomendationAssembly {
    static func build() -> UIViewController {
        let router = RecomendationRouter()
        let repository = MealDBRepository(dependencies: .init(networkService: MealDBNetworkService.shared, storageManagerRecipe: AppAssembly.makeStorageManager(), storageManagerIngredient: AppAssembly.makeStorageManager()))
        let interactor = RecomendationInteractor(depenedencies: .init(recipesRepository: repository))
        let presenter = RecomendationPresenter(dependencies: .init(interactor: interactor, router: router))
        let view = RecipeCollectionView(dependencies: .init(presenter: presenter, downloadable: true, cell: DownloadableRecipeViewCell.self))
        let viewController = RecomendationViewController(dependencies: .init(view: view, presenter: presenter))
        
        router.rootViewController = viewController
        
        presenter.attachView(view: view, controller: viewController)
        
        return viewController
    }
}
