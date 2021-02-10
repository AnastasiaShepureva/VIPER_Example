//
//  ConverterSupport.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 07.02.2021.
//


protocol ConverterSupportProtocol: class {
    
    var currencyList: [CurrencyEntity]? {get set}
    var currencyCodes: [String]? {get set}
    
    var originalCurrency: CurrencyEntity {get set}
    var conversionCurrency: CurrencyEntity {get set}
    
    var originalAmount: Float {get set}
    var convertedAmount: Float {get}
    
    func fillCurrencyList(_ dict: [String: Any])
    func getAndSaveExchangeRatio(_ dict: [String: Any])
    func sortCurrencyList()
}

//MARK: - StoredProperties
class ConverterSupport {
    
    private let storage: StorageSupportProtocol = StorageSupport()
    
    init() {
        originalAmount = storage.loadOriginalAmount() ?? 0.00
        originalCurrency = storage.loadOriginalCurrency() ?? CurrencyEntity.originalDefault
        conversionCurrency = storage.loadConversionCurrency() ?? CurrencyEntity.conversionDefault
    }
    
    var currencyList: [CurrencyEntity]?
    
    var currencyCodes: [String]?
    
    // Observable values:
    var originalCurrency: CurrencyEntity {
        didSet {
            guard oldValue != originalCurrency else {return}
            storage.saveOriginalCurrency(originalCurrency)
            print("First currency: \(originalCurrency.code)")
        }
    }
    
    var conversionCurrency: CurrencyEntity {
        didSet {
            guard oldValue != conversionCurrency else {return}
            storage.saveConversionCurrency(conversionCurrency)
            print("Second currency: \(conversionCurrency.code)")
        }
    }
    
    
    var originalAmount: Float {
        didSet {
            let sum = originalAmount
            storage.saveOriginalAmount(sum)
            print("Original amount: \(originalAmount)")
        }
    }
    
    var convertedAmount: Float {
        get {
            let input = originalAmount
            let result = input * conversionCurrency.exchangeRate
            print("Convertation result: \(result)")
            return result
        }
    }
}
//MARK: - SupportProtocolMethods
extension ConverterSupport: ConverterSupportProtocol {
    
    func fillCurrencyList(_ dict: [String : Any]) {
        currencyList = [CurrencyEntity]()
        currencyCodes = [String]()
        if !dict.isEmpty {
            dict.forEach { (key, value) in
                
                guard let currency = value as? [String : [String : String]] else {fatalError("Cannot convert currency list to dictionary")}
                for (_, value) in currency {
                    if let name = value["currencyName"], let code = value["id"]{
                        let currency = CurrencyEntity(code: code, name: name, exchangeRate: 0)
                        currencyList?.append(currency)
                    }
                }
            }
        }
    }
    
    func getAndSaveExchangeRatio(_ dict: [String : Any]) {
        guard !dict.isEmpty else {return}
        for (_, value) in dict {
            guard let rate = value as? Double else {fatalError("Currency ratio format error")}
            let float = Float(rate)
            conversionCurrency.exchangeRate = float
            storage.saveConversionCurrency(conversionCurrency)
        }
    }
    
    // Updated data sourse for UIPickerView
    func sortCurrencyList() {
        guard currencyList != nil else {return}
        guard !currencyList!.isEmpty else {return}
        currencyList!.sort {($0.name < $1.name)}
        
    }
}
