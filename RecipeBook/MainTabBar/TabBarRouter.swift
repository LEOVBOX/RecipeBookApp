//
//  TabBarRouter.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 21.11.2025.
//

import UIKit

protocol ITabBarRouter {
    func makeTabs() -> [UIViewController]
}

final class TabBarRouter: ITabBarRouter {
    func makeTabs() -> [UIViewController] {
        let recomendations = RecomendationAssembly.build()
        recomendations.tabBarItem = UITabBarItem(title: "Recomendations",
                                                 image: UIImage(systemName: "magnifyingglass"),
                                                 selectedImage: nil)
        
        let saved = SavedRecipesScreenAssembly.build()
        saved.tabBarItem = UITabBarItem(title: "Saved",
                                        image: UIImage(systemName: "star"),
                                        selectedImage: nil)
        
        return [recomendations, saved]
    }
}
