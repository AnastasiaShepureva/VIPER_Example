//
//  ConverterRouter.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//


protocol ConverterRouterProtocol: class {
    func showProductViewController()
}

class ConverterRouter: ConverterRouterProtocol {
    
    weak var viewController: ConverterViewController!
    
    func showProductViewController() {
        viewController.performSegue(withIdentifier: "ProductInfoViewController", sender: self)
    }
    
    required init(viewController: ConverterViewController) {
        self.viewController = viewController
    }
}
