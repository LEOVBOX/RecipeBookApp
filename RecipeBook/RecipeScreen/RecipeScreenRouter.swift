//
//  RecipeScreenRouter.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 20.11.2025.
//

import UIKit

protocol IRecipeScreenRouter {
    func popViewController()
}

class RecipeScreenRouter: IRecipeScreenRouter {
    weak var rootViewController: UIViewController?
    
    func popViewController() {
        rootViewController?.navigationController?.popViewController(animated: true)
    }
}
