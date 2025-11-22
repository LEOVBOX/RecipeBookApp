//
//  RecomendationPresenter.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import Foundation
import UIKit

protocol IRecomendationPresenter: IRecipeCollectionPresenter {
    func attachView(view: IRecipeCollectionView, controller: IRecomendationViewController)
}

final class RecomendationPresenter {
    private var isLoading = false
    private var meals: [MealViewModel] = []
    
    private let interactor: IRecomendationInteractor
    private let router: IRecomendationRouter
    weak var viewController: IRecomendationViewController?
    weak var view: IRecipeCollectionView?
    
    struct Dependencies {
        let interactor: IRecomendationInteractor
        let router: IRecomendationRouter
    }
    
    init(dependencies: Dependencies) {
        self.router = dependencies.router
        self.interactor = dependencies.interactor
    }
}

extension RecomendationPresenter: IRecomendationPresenter {
    func selectedCellAction(with id: String) {
        // TODO: add saving
    }
    
    func loadMoreMeals() {
        guard !isLoading else { return }
        isLoading = true
        
        interactor.getNewRandomMeals { [weak self] newMeals in
            DispatchQueue.main.async {
                let newVM = newMeals
                    .map {
                        MealViewModel(
                            id: $0.idMeal,
                            name: $0.strMeal ?? "",
                            imageURL: $0.strMealThumb
                        )
                    }
                
                self?.meals.append(contentsOf: newVM)
                
                self?.view?.appendMeals(newVM)
                self?.isLoading = false
            }
        }
    }
    
    func viewDidLoad() {
        interactor.getNewRandomMeals { [weak self] mealsModels in
            let vm = mealsModels.map {
                MealViewModel(id: $0.idMeal, name: $0.strMeal ?? "", imageURL: $0.strMealThumb)
            }
            
            DispatchQueue.main.async {
                self?.view?.configure(recipes: vm)
            }
        }
    }

    
    func attachView(view: IRecipeCollectionView, controller: IRecomendationViewController) {
        self.view = view
        self.viewController = controller
    }
    
    func didSelectMeal(with id: String) {
        self.router.openMealScreen(with: id)
    }
}
