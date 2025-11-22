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
        configureTabBarAppearance()
    }

    func setTabs(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tabBar.insertSubview(blurView, at: 0)
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.2)

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
