//
//  RecomendationInteractor.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import Foundation
import UIKit

protocol IRecomendationInteractor {
    func didSelectMeal(with id: String) -> Meal?
    func getNewRandomMeals(completion: @escaping ([Meal]) -> Void)
}

class RecomendationInteractor: IRecomendationInteractor {
    private enum Constants {
        static let pageSize = 8
    }
    
    var recipes: [Meal] = []
    var recipesRepository: IMealDBRepository
    
    struct Dependencies {
        let recipesRepository: IMealDBRepository
    }
    
    init(depenedencies: Dependencies) {
        self.recipesRepository = depenedencies.recipesRepository
    }
    
    private func getNewRandomMeal(oldMeals: [Meal], completion: @escaping (Meal?) -> Void) {
        recipesRepository.getRandomMeal { result in
            switch result {
            case .success(let meal):
                guard
                    let meal,
                    oldMeals.contains(where: { $0.idMeal == meal.idMeal }) == false
                else {
                    completion(nil)
                    return
                }
                completion(meal)

            case .failure(let error):
                print("Error loading meal: \(error)")
                completion(nil)
            }
        }
    }
    
    func didSelectMeal(with id: String) -> Meal? {
        guard let meal = recipes.first(where: { $0.idMeal == id }) else { return nil }
        return meal
    }
    
    func getNewRandomMeals(completion: @escaping ([Meal]) -> Void) {
        var meals: [Meal] = []
        var failedAttempts = 0
        
        func loadNext() {
            if meals.count == Constants.pageSize || failedAttempts == 10 {
                completion(meals)
                return
            }

            getNewRandomMeal(oldMeals: self.recipes) { [weak self] meal in
                guard let self = self else { return }

                if let meal = meal {
                    self.recipes.append(meal)
                    meals.append(meal)
                } else {
                    failedAttempts += 1
                }

                loadNext()
            }
        }

        loadNext()
    }
}
