//
//  TabBarView.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 21.11.2025.
//

import UIKit

protocol ITabBarView: AnyObject {
    func setTabs(_ viewControllers: [UIViewController])
}

final class TabBarViewController: UITabBarController, ITabBarView {
    var presenter: ITabBarPresenter
    
    struct Dependencies {
        let presenter: ITabBarPresenter
    }
    
    init(dependencies: Dependencies) {
        self.presenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    func setTabs(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
}
