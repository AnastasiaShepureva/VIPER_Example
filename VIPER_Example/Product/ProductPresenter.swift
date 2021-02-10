//
//  ProductPresenter.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//

protocol ProductPresenterProtocol: class {
    
    func configure(_ viewController: ProductViewController)
    
    var router: ProductRouterProtocol! {get set}
   
    func cancel()
    func goToUrl(_ urlString: String?)
}

//MARK: - StoredProperties
class ProductPresenter {
    
    weak var view: ProductViewProtocol!
    var interactor: ProductInteractorProtocol!
    var router: ProductRouterProtocol!
    
    required init(view: ProductViewProtocol) {
        self.view = view
    }
}

//MARK: - PresenterProtocolFunctions
extension ProductPresenter: ProductPresenterProtocol {

    func configure(_ viewController: ProductViewController) {
        let interactor = ProductInteractor(presenter: self)
        let router = ProductRouter(viewController: viewController)
        
        viewController.presenter = self
        self.interactor = interactor
        self.router = router
        
        setupView()
    }
    
    func cancel() {
        router.dismissProductViewController()
    }
    
    func goToUrl(_ urlString: String?) {
        guard let url = urlString else {return}
        interactor.openURL(url)
    }
}
//MARK: - UIConfigurations
extension ProductPresenter {
    
    private func setupView() {
        view.configureBatton(interactor.urlRatesSource)
        let text = "Information on exchange rates obtained from:"
        view.configureProductDescriptionLabel(text)
    }
}
