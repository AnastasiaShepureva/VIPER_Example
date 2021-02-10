//
//  CurrencyEntity.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 07.02.2021.
//


class CurrencyEntity: Codable, Equatable {
    
    static func == (lhs: CurrencyEntity, rhs: CurrencyEntity) -> Bool {
        guard lhs.code == rhs.code, lhs.name == rhs.name, lhs.exchangeRate == rhs.exchangeRate else {return false}
        return true
    }
    
    let code: String
    let name: String
    var exchangeRate: Float
    
    init(code: String, name: String, exchangeRate: Float) {
        self.code = code
        self.name = name
        self.exchangeRate = exchangeRate
    }
    
    static var originalDefault = CurrencyEntity(code: "USD", name: "United States Dollar", exchangeRate: 0)
    static var conversionDefault = CurrencyEntity(code: "EUR", name: "Euro", exchangeRate: 0)
    
}
