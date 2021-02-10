//
//  ServerSupport.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//

import UIKit

protocol ServerSupportProtocol: class {
    var sourceURL: String {get}
    func openURL(_ urlString: String)
    func loadCurrencyList(_ dict: @escaping([String : Any]) -> Void)
    func loadExchangeRates(original: String, conversion: String, dict: @escaping([String:Any]) -> Void)
}

class ServerSupport: ServerSupportProtocol {

    var sourceURL: String {
        return "https://free.currencyconverterapi.com"
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func loadCurrencyList(_ dict: @escaping ([String : Any]) -> Void) {
        
        let currencyListURL = "https://free.currconv.com/api/v7/currencies?apiKey=[apiKey]"
        
        guard let url = URL(string: currencyListURL) else {fatalError("Currency list url URL found")}
        
        parseJSON(url: url, result: dict)
        
    }
    
    func loadExchangeRates(original: String, conversion: String, dict: @escaping ([String : Any]) -> Void) {
        
        let currencyExchangeURL = "https://free.currconv.com/api/v7/convert?q=\(original)_\(conversion)&compact=ultra&apiKey=[apiKey]"
        
        guard let url = URL(string: currencyExchangeURL) else {fatalError("Exchange rates URL not found")}
        
        parseJSON(url: url, result: dict)
    }
}

extension ServerSupport {
    
    private func parseJSON(url: URL, result: @escaping( [String : Any]) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
            
            guard error == nil else {return result([:])}
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print(json)
                    result(json)
                } catch {
                    print(error.localizedDescription)
                    result([:])
                }
            }
        }.resume()
    }
}
