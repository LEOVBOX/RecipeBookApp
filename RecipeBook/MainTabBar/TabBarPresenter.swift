//
//  TabBarPresenter.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 21.11.2025.
//

import Foundation

protocol ITabBarPresenter {
    func viewDidLoad()
    func attachView(view: ITabBarView)
}

final class TabBarPresenter: ITabBarPresenter {
    weak var view: ITabBarView?
    var router: ITabBarRouter
    
    init(router: ITabBarRouter) {
        self.router = router
    }
    
    func attachView(view: ITabBarView) {
        self.view = view
    }
    
    func viewDidLoad() {
        let tabs = router.makeTabs()
        DispatchQueue.main.async { [weak self] in
            self?.view?.setTabs(tabs)
        }
        
    }
}
