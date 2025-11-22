//
//  StorageManager.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 21.11.2025.
//

import Foundation
import CoreData

protocol IStorageManagerRecipe {
    func loadRecipes() -> [Recipe]
    func getRecipe(by id: String) throws -> [Recipe]? 
    func saveRecipe(model: MealFullDetails) throws -> Recipe?
    func deleteRecipe(for index: String) throws
    var context: NSManagedObjectContext { get }
}

protocol IStorageManagerIngredient {
    func loadIngredients(for recipe: Recipe) -> [Ingredient]
}

final class StorageManager {
    let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext) {
        self.mainContext = mainContext
    }
    
    private func saveContext() {
        try? mainContext.save()
    }
}

extension StorageManager: IStorageManagerRecipe {
    var context: NSManagedObjectContext { self.mainContext }
    
    func getRecipe(by id: String) throws -> [Recipe]? {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return (try? mainContext.fetch(request))
    }
    
    func loadRecipes() -> [Recipe] {
        do {
            let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            return try self.mainContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func saveRecipe(model: MealFullDetails) throws -> Recipe? {
        // Is there already saved recipe with same id?
        let recipesWithId = try getRecipe(by: model.id)
        if let recipe = recipesWithId?.first {
            return recipe
        }
        
        var newRecipe: Recipe? = nil
        
        try context.performAndWait {
            newRecipe = Recipe(context: context)
            newRecipe?.id = model.id
            newRecipe?.title = model.name
            newRecipe?.imageURL = model.thumbnail
            newRecipe?.instruction = model.instructions
            
            for ingredientModel in model.ingredients {
                let ingredient = Ingredient(context: context)
                ingredient.title = ingredientModel.name
                ingredient.measure = ingredientModel.measure
                ingredient.recipe = newRecipe
            }
            
            try context.save()
        }
        
        return newRecipe
        
    }
    
    func deleteRecipe(for id: String) throws {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let recipe = try mainContext.fetch(request).first
        guard let recipe else { return }
        mainContext.delete(recipe)
        saveContext()
    }
}

extension StorageManager: IStorageManagerIngredient {
    func loadIngredients(for recipe: Recipe) -> [Ingredient] {
        do {
            let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
            request.predicate = NSPredicate(format: "recipe == %@", recipe)
            return try self.mainContext.fetch(request)
        } catch {
            return []
        }
    }
}
