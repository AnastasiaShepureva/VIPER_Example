//
//  StorageSupport.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 07.02.2021.
//

import Foundation

protocol StorageSupportProtocol: class {
    
    func loadOriginalAmount() -> Float?
    func loadOriginalCurrency() -> CurrencyEntity?
    func loadConversionCurrency() -> CurrencyEntity?
    
    func saveOriginalAmount(_ sum: Float?)
    func saveOriginalCurrency(_ code: CurrencyEntity?)
    func saveConversionCurrency(_ code: CurrencyEntity?)
}

class StorageSupport: StorageSupportProtocol {
    
    //Keys:
    private let originalAmountKey = "originalAmountKey"
    private let originalCurrencyKey = "originalCurrencyKey"
    private let conversionCirrencyKey = "conversionCirrencyKey"
    
    //Load data
    func loadOriginalAmount() -> Float? {
        if UserDefaults.standard.object(forKey: originalAmountKey) != nil {
            return UserDefaults.standard.float(forKey: originalAmountKey)
        }
        return nil
    }
    
    func loadOriginalCurrency() -> CurrencyEntity? {
        guard let currency = UserDefaults.standard.value(forKey: originalCurrencyKey) else {return nil}
        guard let data = currency as? Data else {fatalError("Cannot convert currency to data")}
        let result = try? PropertyListDecoder().decode(CurrencyEntity.self, from: data)
        return result
    }
    
    func loadConversionCurrency() -> CurrencyEntity? {
        guard let currency = UserDefaults.standard.value(forKey: conversionCirrencyKey) else {return nil}
        guard let data = currency as? Data else {fatalError("Cannot convert currency to data")}
        let result = try? PropertyListDecoder().decode(CurrencyEntity.self, from: data)
        return result
    }
    
    //Save data
    func saveOriginalAmount(_ sum: Float?) {
        guard let sum = sum else {return}
        UserDefaults.standard.set(sum, forKey: originalAmountKey)
    }
    
    func saveOriginalCurrency(_ code: CurrencyEntity?) {
        guard let code = code else {return}
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(code), forKey: originalCurrencyKey)
    }
    
    func saveConversionCurrency(_ code: CurrencyEntity?) {
        guard let code = code else {return}
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(code), forKey: conversionCirrencyKey)
    }
    
    
}
