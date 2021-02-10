//
//  ProductRouter.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//


protocol ProductRouterProtocol: class {
    func dismissProductViewController()
}

class ProductRouter: ProductRouterProtocol {
    
    weak var viewController: ProductViewController!
    func dismissProductViewController() {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
    required init(viewController: ProductViewController) {
        self.viewController = viewController
    }
}
