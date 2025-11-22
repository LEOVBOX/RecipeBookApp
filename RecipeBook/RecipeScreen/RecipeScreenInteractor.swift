//
//  RecipeScreenInteractor.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 20.11.2025.
//

protocol IRecipeScreenInteractor: AnyObject {
    func getMealFullDetails(isSaved: Bool, completion: @escaping (MealFullDetails?) -> Void)
    func deleteRecipe(completion: @escaping ( ) -> Void)
    func saveRecipe(completion: @escaping ()->Void)
}

class RecipeScreenInteractor {
    var mealId: String
    var repository: IMealDBRepository
    var imageRepository: IImageRepository?
    var mealDetails: MealFullDetails?
    
    struct Dependencies {
        let mealId: String
        let recipeRepository: IMealDBRepository
        let imageRepository: IImageRepository
    }
    
    init(dependencies: Dependencies) {
        self.mealId = dependencies.mealId
        self.repository = dependencies.recipeRepository
        self.imageRepository = dependencies.imageRepository
    }
}

extension RecipeScreenInteractor: IRecipeScreenInteractor {
    
    func deleteRecipe(completion: @escaping ()->Void) {
        repository.deleteRecipe(with: mealId) { _ in 
            completion()
        }
    }
    
    func saveRecipe(completion: @escaping ()->Void) {
        guard let mealDetails else {
            return
        }
        repository.saveRecipe(with: mealDetails) { result in
            switch result {
                case .success:
                    completion()
                case .failure(let error):
                    print("Error saving recipe: \(error)")
                    completion()
            }
             
        }
        guard let thumbnail = mealDetails.thumbnail else {
            return
        }
        imageRepository?.saveImage(url: thumbnail)
        for ingredient in mealDetails.ingredients {
            guard let endpoint = getIngredientEndpoint(for: ingredient.name) else { return }
            imageRepository?.saveImage(url: endpoint)
        }
        completion()
    }
    
    
    func getMealFullDetails(isSaved: Bool, completion: @escaping (MealFullDetails?) -> Void) {
        if isSaved {
            repository.getRecipe(id: mealId) {[weak self] recipe in
                guard let recipe else {
                    completion(nil)
                    return
                }
                
                self?.repository.getIngredients(for: recipe) { ingredients in
                    let ingredientsModels = ingredients.map {
                        MealFullDetails.Ingredient(name: $0.title ?? "", measure: $0.measure ?? "")
                    }
                    
                    let mealFullDetails = MealFullDetails(
                        id: recipe.id,
                        name: recipe.title ?? "",
                        category: nil,
                        area: nil,
                        instructions: recipe.instruction,
                        thumbnail: recipe.imageURL,
                        tags: nil,
                        youtubeUrl: nil,
                        ingredients: ingredientsModels
                    )
                    
                    completion(mealFullDetails)
                    return
                }
            }
        }
        repository.getMealDetails(id: mealId) { result in
            switch result {
                case .success(let mealDetails):
                    self.mealDetails = mealDetails
                    completion(mealDetails)
                    return
                case .failure(let error):
                    print("Error loading meal details: \(error)")
                    completion(nil)
            }
        }
    }
}

