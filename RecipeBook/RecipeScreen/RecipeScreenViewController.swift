//
//  RecipeScreenViewController.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 20.11.2025.
//

import UIKit

protocol IRecipeScreeViewController {
    func setupRightNavBarItem(buttonTitle: String, action: (()->())?)
    func navBarItemTapped()
}

final class RecipeScreenViewController: UIViewController, IRecipeScreeViewController {
    func navBarItemTapped() {
        UIView.animate(withDuration: 0.3) {
            self.navigationItem.rightBarButtonItem?.isHidden = true
        }
    }
    
    private let contentView: IRecipeView
    private let presenter: IRecipeScreenPresenter
    
    private var action: (() -> (Void))?
    
    struct Dependencies {
        let view: IRecipeView
        let presenter: IRecipeScreenPresenter
    }
    
    init(dependencies: Dependencies) {
        self.contentView = dependencies.view
        self.presenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    func setupRightNavBarItem(buttonTitle: String, action: (()->())?) {
        self.action = action
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(rightBarButtonAction))
    }
}

private extension RecipeScreenViewController {
    @objc func rightBarButtonAction() {
        action?()
    }
}
