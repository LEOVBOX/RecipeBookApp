//
//  RecomendationPresenter.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import Foundation

protocol ISavedRecipesScreenPresenter: IRecipeCollectionPresenter {
    func attachView(view: IRecipeCollectionView, controller: SavedRecipesScreenViewController)
}

class SavedRecipesScreenPresenter {
    private var isLoading = false
    private var recipes: [MealViewModel] = []
    
    private let interactor: ISavedRecipesScreenInteractor
    private let router: ISavedRecipesScreenRouter
    weak var viewController: SavedRecipesScreenViewController?
    weak var view: IRecipeCollectionView?
    
    struct Dependencies {
        let interactor: ISavedRecipesScreenInteractor
        let router: ISavedRecipesScreenRouter
    }
    
    init(dependencies: Dependencies) {
        self.router = dependencies.router
        self.interactor = dependencies.interactor
    }
}

extension SavedRecipesScreenPresenter: ISavedRecipesScreenPresenter {
    func selectedCellAction(with id: String) {
        interactor.deleteRecipe(with: id) {
            self.view?.update()
        }
    }
    
    func loadMoreMeals() {
        interactor.getSavedRecipes { [weak self] recipesModels in
            DispatchQueue.main.async {
                guard recipesModels.isEmpty == false else { return }
                let newVM = recipesModels.map {
                    MealViewModel(id: $0.id, name: $0.title ?? "", imageURL: $0.imageURL)
                }
                
                self?.recipes.append(contentsOf: newVM)
                
                self?.view?.appendMeals(newVM)
                self?.isLoading = false
            }
        }
    }
    
    func attachView(view: IRecipeCollectionView, controller: SavedRecipesScreenViewController) {
        self.view = view
        self.viewController = controller
    }
    
    func viewDidLoad() {
        interactor.getSavedRecipes { [weak self] recipesModels in
            let mealsViewModels = recipesModels
                .map { recipe in
                    return MealViewModel(
                        id: recipe.id,
                        name: recipe.title ?? "",
                        imageURL: recipe.imageURL
                    )
                }
            
            DispatchQueue.main.async {
                self?.view?.configure(recipes: mealsViewModels)
            }
        }
    }
    
    func didSelectMeal(with id: String) {
        self.router.openRecipeScreen(with: id)
    }
}
