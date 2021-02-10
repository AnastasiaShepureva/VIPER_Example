//
//  ProductInteractor.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//


protocol ProductInteractorProtocol: class {
    var urlRatesSource: String {get}
    func openURL(_ urlString: String)
}
//MARK: - StoredProperties
class ProductInteractor {
    weak var presenter: ProductPresenterProtocol!
    let serverService: ServerSupportProtocol = ServerSupport()
    
    required init(presenter: ProductPresenter) {
        self.presenter = presenter
    }
}
//MARK: - ProtocolDelegatedActions
extension ProductInteractor: ProductInteractorProtocol{
    
    var urlRatesSource: String {
        get {
            return serverService.sourceURL
        }
    }
    
    func openURL(_ urlString: String) {
        serverService.openURL(urlString)
    }
}
