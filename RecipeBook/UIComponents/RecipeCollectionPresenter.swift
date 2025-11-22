//
//  RecipeCollectionPresenter.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 21.11.2025.
//

import UIKit

protocol IRecipeCollectionPresenter {
    func didSelectMeal(with id: String)
    func selectedCellAction(with id: String)
    func viewDidLoad()
    func loadMoreMeals()
}
