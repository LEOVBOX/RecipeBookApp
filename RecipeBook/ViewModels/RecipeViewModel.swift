//
//  RecipeViewModel.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 20.11.2025.
//

struct RecipeViewModel {
    var title: String
    var instructions: String
    var imageURL: String?
    
    struct IngredientViewModel {
        let name: String
        let measurement: String
        let imageURL: String?
    }
    
    var ingredients: [IngredientViewModel]
}

extension RecipeViewModel {
    static func getIngredientEndpoint(for ingredientName: String?) -> String? {
        guard let ingredientName else {
            return nil
        }
        return "https://www.themealdb.com/images/ingredients/\(ingredientName)-small.png"
    }
}

