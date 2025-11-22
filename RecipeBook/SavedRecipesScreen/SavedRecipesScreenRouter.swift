//
//  RecomendationRouter.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import UIKit

protocol ISavedRecipesScreenRouter: AnyObject {
    func openRecipeScreen(with recipeId: String)
}

class SavedRecipesScreenRouter: ISavedRecipesScreenRouter {
    weak var rootViewController: UIViewController?
    
    func openRecipeScreen(with recipeId: String) {
        let targetVC = RecipeScreenAssembly.build(mealId: recipeId, isSaved: true)
        self.rootViewController?.navigationController?.pushViewController(targetVC, animated: true)
    }
}

