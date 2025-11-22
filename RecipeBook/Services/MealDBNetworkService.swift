//
//  NetworkService.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//


import Foundation

// MARK: - DTO

private struct RawMealDetails: Decodable {
    let idMeal: String
    let strMeal: String?
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strTags: String?
    let strYoutube: String?
    
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
}

// MARK: - Models

private struct MealDetailsResponse: Decodable {
    let meals: [RawMealDetails]?
}

struct MealsResponse: Decodable {
    let meals: [Meal]?
}

struct Meal: Decodable {
    let idMeal: String
    let strMeal: String?
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
}

struct MealFullDetails {
    let id: String
    let name: String
    let category: String?
    let area: String?
    let instructions: String?
    let thumbnail: String?
    let tags: String?
    let youtubeUrl: String?
    
    struct Ingredient {
        let name: String
        let measure: String
    }
    
    let ingredients: [Ingredient]
}

struct CategoriesResponse: Decodable {
    let categories: [MealCategory]
}

struct MealCategory: Decodable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String?
    let strCategoryDescription: String?
}

struct SimpleListResponse: Decodable {
    let meals: [SimpleItem]
}

struct SimpleItem: Decodable {
    let strCategory: String?
    let strArea: String?
    let strIngredient: String?
}

// MARK: - Errors

enum MealDBError: Error {
    case invalidURL
    case noData
    case httpError
    case decodingError
}

// MARK: - Endpoint Enum

enum MealDBEndpoint {
    case searchByName(String)
    case searchByLetter(Character)
    case lookupFullDetailsById(String)
    case random
    case categories
    case listCategories
    case listAreas
    case listIngredients
    case filterByIngredient(String)
    case filterByCategory(String)
    case filterByArea(String)
    
    var urlString: String {
        switch self {
            case .searchByName(let name):
                "search.php?s=\(name)"
            case .searchByLetter(let letter):
                "search.php?f=\(letter)"
            case .lookupFullDetailsById(let id):
                "lookup.php?i=\(id)"
            case .random:
                "random.php"
            case .categories:
                "categories.php"
            case .listCategories:
                "list.php?c=list"
            case .listAreas:
                "list.php?a=list"
            case .listIngredients:
                "list.php?i=list"
            case .filterByIngredient(let ingredient):
                "filter.php?i=\(ingredient)"
            case .filterByCategory(let category):
                "filter.php?c=\(category)"
            case .filterByArea(let area):
                "filter.php?a=\(area)"
        }
    }
}

protocol IMealDBNetworkService {
    func randomMeal(completion: @escaping (Result<Meal?, MealDBError>) -> Void)
    func lookupMealFullDetails(by id: String, completion: @escaping (Result<MealFullDetails, MealDBError>) -> Void)
}

// MARK: - Service (GCD)

final class MealDBNetworkService: IMealDBNetworkService {
    static let shared = MealDBNetworkService()
    private init() {}
    
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    
    private func fetch<T: Decodable>(
        _ endpoint: MealDBEndpoint,
        type: T.Type,
        completion: @escaping (Result<T, MealDBError>) -> Void
    ) {
        let urlString = baseURL + endpoint.urlString
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let _ = error {
                    completion(.failure(.httpError))
                    return
                }
                
                guard
                    let http = response as? HTTPURLResponse,
                    http.statusCode == 200,
                    let data = data
                else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: Public API
    
    func searchMeal(by name: String, completion: @escaping (Result<[Meal], MealDBError>) -> Void) {
        fetch(.searchByName(name), type: MealsResponse.self) { result in
            switch result {
                case .success(let res): completion(.success(res.meals ?? []))
                case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    func listMeals(byFirstLetter letter: Character, completion: @escaping (Result<[Meal], MealDBError>) -> Void) {
        fetch(.searchByLetter(letter), type: MealsResponse.self) { result in
            switch result {
                case .success(let res): completion(.success(res.meals ?? []))
                case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    func lookupMealFullDetails(by id: String, completion: @escaping (Result<MealFullDetails, MealDBError>) -> Void) {
        fetch(.lookupFullDetailsById(id), type: MealDetailsResponse.self) { result in
            switch result {
                case .success(let response):
                    guard let raw = response.meals?.first else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    completion(.success(raw.toDomain()))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func randomMeal(completion: @escaping (Result<Meal?, MealDBError>) -> Void) {
        fetch(.random, type: MealsResponse.self) { result in
            switch result {
                case .success(let res): completion(.success(res.meals?.first))
                case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    func allCategories(completion: @escaping (Result<[MealCategory], MealDBError>) -> Void) {
        fetch(.categories, type: CategoriesResponse.self) { result in
            switch result {
                case .success(let res): completion(.success(res.categories))
                case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    func listCategories(completion: @escaping (Result<[SimpleItem], MealDBError>) -> Void) {
        fetch(.listCategories, type: SimpleListResponse.self) { result in
            switch result {
                case .success(let res): completion(.success(res.meals))
                case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    func listAreas(completion: @escaping (Result<[SimpleItem], MealDBError>) -> Void) {
        fetch(.listAreas, type: SimpleListResponse.self) { result in
            switch result {
                case .success(let res): completion(.success(res.meals))
                case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    func listIngredients(completion: @escaping (Result<[SimpleItem], MealDBError>) -> Void) {
        fetch(.listIngredients, type: SimpleListResponse.self) { result in
            switch result {
                case .success(let res): completion(.success(res.meals))
                case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    func filter(byIngredient ingredient: String, completion: @escaping (Result<[Meal], MealDBError>) -> Void) {
        fetch(.filterByIngredient(ingredient), type: MealsResponse.self) { result in
            switch result {
                case .success(let res): completion(.success(res.meals ?? []))
                case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    func filter(byCategory category: String, completion: @escaping (Result<[Meal], MealDBError>) -> Void) {
        fetch(.filterByCategory(category), type: MealsResponse.self) { result in
            switch result {
                case .success(let res): completion(.success(res.meals ?? []))
                case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    func filter(byArea area: String, completion: @escaping (Result<[Meal], MealDBError>) -> Void) {
        fetch(.filterByArea(area), type: MealsResponse.self) { result in
            switch result {
                case .success(let res): completion(.success(res.meals ?? []))
                case .failure(let err): completion(.failure(err))
            }
        }
    }
}

private extension RawMealDetails {
    func toDomain() -> MealFullDetails {
        var ingredients: [MealFullDetails.Ingredient] = []
        let mirror = Mirror(reflecting: self)
        
        for i in 1...20 {
            var ingredientValue: String? = nil
            var measureValue: String? = nil
            let keyIngredient = "strIngredient\(i)"
            if let childIngredientName = mirror.children.first(where: { $0.label == keyIngredient }),
               let value = childIngredientName.value as? String,
               !value.trimmingCharacters(in: .whitespaces).isEmpty {
                ingredientValue = value
            }
            guard let ingredientValue else { continue }
            let keyMeasure = "strMeasure\(i)"
            if let childIngredientName = mirror.children.first(where: { $0.label == keyMeasure }),
               let value = childIngredientName.value as? String,
               !value.trimmingCharacters(in: .whitespaces).isEmpty {
                measureValue = value
            }
            
            ingredients.append(MealFullDetails.Ingredient.init(name: ingredientValue, measure: measureValue ?? ""))
        }
        
        return MealFullDetails(
            id: idMeal,
            name: strMeal ?? "",
            category: strCategory,
            area: strArea,
            instructions: strInstructions,
            thumbnail: strMealThumb,
            tags: strTags,
            youtubeUrl: strYoutube,
            ingredients: ingredients
        )
    }
}
