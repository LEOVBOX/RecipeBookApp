//
//  TabBarAssembly.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 21.11.2025.
//

import UIKit

enum TabBarAssembly {
    static func build() -> UIViewController {
        let router = TabBarRouter()
        let presenter = TabBarPresenter(router: router)
        let view = TabBarViewController(dependencies: .init(presenter: presenter))
        
        presenter.attachView(view: view)
        return view
    }
}
