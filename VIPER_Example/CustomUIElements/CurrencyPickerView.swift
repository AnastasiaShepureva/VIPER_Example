//
//  CurrencyPickerView.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//

import UIKit

protocol CurrencyPickerViewConfigurationsProtocol: class {
    var currencies: [CurrencyEntity] {get set}
    var selectedCurrency: CurrencyEntity? {get set}
    var selectedCurrencyCode: String? {get set}
    func reloadRows()
    func scrollToDefaultValue()
}

protocol CurrencyPickerViewDelegate: class {
    func applyCurrency(_ value: CurrencyEntity)
    func cancel()
}

class CurrencyPickerView: UIView {
    //MARK: - Constants:
    var currencies: [CurrencyEntity] = []
    var selectedCurrency: CurrencyEntity?
    var selectedCurrencyCode: String?
    weak var actionDelegate: CurrencyPickerViewDelegate?
    
    //MARK: - UIElements:
    @IBOutlet var view: UIView!

    @IBOutlet weak var currencyPickerView: UIPickerView!

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        actionDelegate?.cancel()
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        guard let selectedCurrency = selectedCurrency else {return}
        actionDelegate?.applyCurrency(selectedCurrency)
    }
    
    //MARK: - Initializing
    private func setupPickerView() {
        Bundle.main.loadNibNamed("CurrencyPickerView", owner: self, options: nil)
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPickerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPickerView()
    }
    
}

//MARK: - Presenter's Delegated Actions
extension CurrencyPickerView: CurrencyPickerViewConfigurationsProtocol {
    
    func scrollToDefaultValue() {
        guard let selectedValue = selectedCurrencyCode else {return}
        var defaultCurrency: CurrencyEntity!
        currencies.forEach { (currency) in
            if currency.code == selectedValue {
                defaultCurrency = currency
            }
        }
        if currencies.contains(defaultCurrency) {
            guard let index = currencies.firstIndex(of: defaultCurrency) else {fatalError("Currency not found")}
            currencyPickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    func reloadRows() {
        currencyPickerView.reloadAllComponents()
        print(currencies.count)
    }
    
}

//MARK: - PickerViewConfigurations
extension CurrencyPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencies[row]
    }
}
