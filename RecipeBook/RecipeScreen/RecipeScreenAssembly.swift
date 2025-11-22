//
//  RecipeScreenAssembly.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 20.11.2025.
//

import UIKit

class RecipeScreenAssembly {
    static func build(mealId: String, isSaved: Bool = false) -> UIViewController {
        let router = RecipeScreenRouter()
        let repository = MealDBRepository(dependencies: .init(networkService: MealDBNetworkService.shared, storageManagerRecipe: AppAssembly.makeStorageManager(), storageManagerIngredient: AppAssembly.makeStorageManager()))
        let interactor = RecipeScreenInteractor(dependencies: .init(mealId: mealId, recipeRepository: repository, imageRepository: ImageRepository.shared))
        let presenter = RecipeScreenPresenter(dependencies: .init(interactor: interactor, router: router, saved: isSaved))
        
        let view: IRecipeView = isSaved ?
            RecipeView(dependencies: .init(presenter: presenter)) :
            DownloadableRecipeView(dependencies: .init(presenter: presenter))
            
        
        let viewController = RecipeScreenViewController(dependencies: .init(view: view, presenter: presenter))
        
        router.rootViewController = viewController
        
        presenter.attachView(view: view, controller: viewController)
        
        return viewController
    }
}


