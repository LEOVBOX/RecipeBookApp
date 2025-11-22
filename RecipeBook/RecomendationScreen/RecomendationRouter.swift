//
//  RecomendationRouter.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 16.11.2025.
//

import UIKit

protocol IRecomendationRouter: AnyObject {
    func openMealScreen(with mealId: String)
}

class RecomendationRouter: IRecomendationRouter {
    weak var rootViewController: UIViewController?
    
    func openMealScreen(with mealId: String) {
        let targetVC = RecipeScreenAssembly.build(mealId: mealId)
        self.rootViewController?.navigationController?.pushViewController(targetVC, animated: true)
    }
}

