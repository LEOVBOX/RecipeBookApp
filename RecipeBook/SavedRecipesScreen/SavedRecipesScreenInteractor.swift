//
//  RecomendationInteractor.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import Foundation
import UIKit

protocol ISavedRecipesScreenInteractor {
    func getSavedRecipes(completion: @escaping ([Recipe]) -> Void)
    func deleteRecipe(with id: String, completion: @escaping () -> Void)
}

class SavedRecipesScreenInteractor: ISavedRecipesScreenInteractor {
    var recipes: [Recipe] = []
    var recipesRepository: IMealDBRepository
    
    struct Dependencies {
        let recipesRepository: IMealDBRepository
    }
    
    init(depenedencies: Dependencies) {
        self.recipesRepository = depenedencies.recipesRepository
    }
    
    func getSavedRecipes(completion: @escaping ([Recipe]) -> Void) {
        recipesRepository.getSavedRecipes { result in
            switch result {
                case .success(let recipes):
                    completion(recipes)
                    
                case .failure(let error):
                    print("Error loading recipes: \(error)")
            }
        }
    }
    
    func deleteRecipe(with id: String, completion: @escaping () -> Void) {
        recipesRepository.deleteRecipe(with: id) { result in
            switch result {
                case .success(_):
                    completion()
                    return
                case .failure(let error):
                    print("Error deleting recipe: \(error)")
            }
        }
    }
}
