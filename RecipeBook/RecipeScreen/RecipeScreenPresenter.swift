//
//  RecipeScreenPresenter.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 20.11.2025.
//

import Foundation


protocol IRecipeScreenPresenter: AnyObject {
    func attachView(view: IRecipeView, controller: RecipeScreenViewController)
    func viewDidLoad()
    var saved: Bool { get }
}

class RecipeScreenPresenter {
    private let interactor: IRecipeScreenInteractor
    private let router: IRecipeScreenRouter
    weak var viewController: RecipeScreenViewController?
    weak var view: IRecipeView?
    
    internal let saved: Bool
    
    struct Dependencies {
        let interactor: IRecipeScreenInteractor
        let router: IRecipeScreenRouter
        let saved: Bool
    }
    
    init(dependencies: Dependencies) {
        self.router = dependencies.router
        self.interactor = dependencies.interactor
        self.saved = dependencies.saved
    }
}

extension RecipeScreenPresenter: IRecipeScreenPresenter {
    private func saveRecipe(completion: @escaping ()->Void) {
        interactor.saveRecipe {
            completion()
        }
    }
    
    private func deleteRecipe(completion: @escaping ()->Void) {
        interactor.deleteRecipe {
            completion()
        }
    }
    
    func attachView(view: any IRecipeView, controller: RecipeScreenViewController) {
        self.view = view
        self.viewController = controller
    }
    
    func viewDidLoad() {
        interactor.getMealFullDetails(isSaved: saved) { [weak self] mealDetails in
            guard let mealDetails else { return }
            
            DispatchQueue.main.async {
                let ingredientsViewModel = mealDetails.ingredients
                    .map {
                        RecipeViewModel.IngredientViewModel(
                            name: $0.name,
                            measurement: $0.measure,
                            imageURL: RecipeViewModel.getIngredientEndpoint(for: $0.name) ?? ""
                        )
                    }
                
                let viewModel = RecipeViewModel(
                    title: mealDetails.name,
                    instructions: mealDetails.instructions ?? "",
                    imageURL: mealDetails.thumbnail ?? "",
                    ingredients: ingredientsViewModel
                )
                
                guard let self else { return }
                
                self.view?.configure(with: viewModel)
                
                var actionFunc: (() -> ())?

                if self.saved {
                    actionFunc = { self.deleteRecipe(completion: self.router.popViewController) }
                } else {
                    actionFunc = {
                        self.saveRecipe {
                            self.viewController?.navBarItemTapped()
                        }
                    }
                }

                
                self.viewController?.setupRightNavBarItem(
                    buttonTitle: self.saved ? "Delete" : "Save",
                    action: actionFunc
                )
            }
        }
    }
}
