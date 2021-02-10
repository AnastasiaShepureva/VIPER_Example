//
//  ConverterInteractior.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//


protocol ConverterInteractorProtocol: class {

    var originalCurrecyCode: String? {get set}
    var conversionCurrecyCode: String? {get set}
    
    var originalAmount: Float? {get set}
    var convertedAmount: Float? {get}
    
    func originalCurrecyEditing()
    func conversionCurrencyEditing()
    
    func currencyDidChange(_ value: CurrencyEntity)
    
    func loadCurrencies()
    func setCurrencies() -> [CurrencyEntity]
}

class ConverterInteractior: ConverterInteractorProtocol {

    enum Kind {
        case original, conversion
    }
    //MARK: - StoredProperties:
    weak var presenter: ConverterPresenterProtocol!
    
    var kind: Kind?
    var converter: ConverterSupportProtocol = ConverterSupport()
    let server: ServerSupportProtocol = ServerSupport()
    
    //MARK: - ProtocolConstants
    var originalCurrecyCode: String? {
        get {
            return converter.originalCurrency.code
        }
        set{}
    }
    
    var conversionCurrecyCode: String? {
        get {
            return converter.conversionCurrency.code
        }
        set{}
    }
    
    var originalAmount: Float? {
        get {
            return converter.originalAmount
        }
        set {
            converter.originalAmount = newValue ?? 0.00
            calculate()
        }
    }
    
    var convertedAmount: Float? {
        get {
            return converter.convertedAmount
        }
    }
    
    required init(presenter: ConverterPresenterProtocol) {
        self.presenter = presenter
    }
}

extension ConverterInteractior {
    func currencyDidChange(_ value: CurrencyEntity) {
        switch kind {
        case .original:
            converter.originalCurrency = value
            presenter.originalCurrencyCodeChanged(value.code)
            converter.originalCurrency = value
        case .conversion:
            converter.conversionCurrency = value
            presenter.conversionCurrencyCodeChanged(value.code)
            converter.conversionCurrency = value
        default:
            break
        }

        calculate()
    }
    private func calculate(){
        server.loadExchangeRates(original: originalCurrecyCode!, conversion: conversionCurrecyCode!) {(dict) in
            guard !dict.isEmpty else {fatalError("Dictionary of exchange rates not found")}
            
            self.converter.getAndSaveExchangeRatio(dict)
            
            self.presenter.updateValues()
        }
    }
    
    func loadCurrencies() {
        server.loadCurrencyList {[self] (dict) in
            guard !dict.isEmpty else {fatalError("Loading currency dictionary error")}
            converter.fillCurrencyList(dict)
            converter.sortCurrencyList()
        }
    }
    
    func setCurrencies() -> [CurrencyEntity] {
        return converter.currencyList ?? []
    }
}

extension ConverterInteractior {
    
    func conversionCurrencyEditing() {
        self.kind = .conversion
    }
    
    func originalCurrecyEditing() {
        self.kind = .original
    }
}
