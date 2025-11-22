//
//  MealDBRepository.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import UIKit

protocol IMealDBRepository: AnyObject {
    func getRandomMeals(number: Int, completion: @escaping (Result<[Meal], Error>) -> Void)
    func getRandomMeal(completion: @escaping (Result<Meal?, Error>) -> Void)
    func getMealDetails(id: String, completion: @escaping (Result<MealFullDetails, Error>) -> Void)
    func getSavedRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void)
    func getRecipe(id: String, completion: @escaping (Recipe?) -> Void)
    func getIngredients(for recipe: Recipe, completion: @escaping ([Ingredient]) -> Void)
    func saveRecipe(with details: MealFullDetails, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteRecipe(with id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class MealDBRepository: IMealDBRepository {
    private let networkService: IMealDBNetworkService
    private let recipesStorageManager: IStorageManagerRecipe
    private let ingredientsStorageManager: IStorageManagerIngredient
    
    struct Dependencies {
        let networkService: IMealDBNetworkService
        let storageManagerRecipe: IStorageManagerRecipe
        let storageManagerIngredient: IStorageManagerIngredient
    }
    
    init(dependencies: Dependencies) {
        self.networkService = dependencies.networkService
        self.recipesStorageManager = dependencies.storageManagerRecipe
        self.ingredientsStorageManager = dependencies.storageManagerIngredient
    }
    
    func getRandomMeal(completion: @escaping (Result<Meal?, any Error>) -> Void) {
        networkService.randomMeal { result in
            switch result {
                case .success(let meal):
                    completion(.success(meal))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func getRandomMeals(number: Int, completion: @escaping (Result<[Meal], Error>) -> Void) {
        var meals: [Meal] = []
        let dispatchGroup = DispatchGroup()
        var errors: [Error] = []
        
        for _ in 1...number {
            dispatchGroup.enter()
            
            networkService.randomMeal { result in
                switch result {
                    case .success(let meal):
                        if let meal = meal {
                            meals.append(meal)
                        }
                    case .failure(let error):
                        errors.append(error)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if !errors.isEmpty {
                completion(.failure(errors.first!))
            } else {
                completion(.success(meals))
            }
        }
    }
    
    func getRecipe(id: String, completion: @escaping (Recipe?) -> Void) {
        getSavedRecipes { result in
            switch result {
                case .success(let recipes):
                    if let recipe = recipes.first(where: { $0.id == id }) {
                        completion(recipe)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print("Error loading saved recipes: \(error)")
                    completion(nil)
            }
        }
    }
    
    func getIngredients(for recipe: Recipe, completion: @escaping ([Ingredient]) -> Void) {
        completion(ingredientsStorageManager.loadIngredients(for: recipe))
    }
    
    func getMealDetails(id: String, completion: @escaping (Result<MealFullDetails, any Error>) -> Void) {
        networkService.lookupMealFullDetails(by: id) { result in
            switch result {
                case .success(let meal):
                    completion(.success(meal))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func getSavedRecipes(completion: @escaping (Result<[Recipe], any Error>) -> Void) {
        completion(.success(recipesStorageManager.loadRecipes()))
    }
    
    func saveRecipe(with details: MealFullDetails, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let recipe = try recipesStorageManager.saveRecipe(model: details)
            guard recipe != nil else {
                completion(.failure(StorageManagerError.fileWriteError))
                return
            }
        }
        catch {
            print("Error saving recipe: \(error)")
        }
    }
    
    func deleteRecipe(with id: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            try recipesStorageManager.deleteRecipe(for: id)
            completion(.success(()))
        }
        catch {
            print("Error deleting recipe: \(error)")
        }
    }
    
}

enum StorageManagerError: Error {
    case fileWriteError
}
