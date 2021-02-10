//
//  ConverterPresenter.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//


protocol ConverterPresenterProtocol: class {
    func configure(_ viewController: ConverterViewController)

    var router: ConverterRouterProtocol! {get set}
    func originalCurrencyButtonTapped()
    func conversionCurrencyButtonTapped()
    func textFieldBeginEditing()
    
    func originalCurrencyCodeChanged(_ value: String)
    func conversionCurrencyCodeChanged(_ value: String)
    func originalAmountChanged(_ value: String)
    
    var originalCurrencyCode: String {get}
    var conversionCurrencyCode: String {get}
    var originalAmountString: String {get set}
    var convertedAmountString: String {get}
    
    func updateValues()
    func infoButtonTapped()
    
}

//MARK: - Constants:
class ConverterPresenter {
    weak var view: ConverterViewProtocol!
    weak var picker: CurrencyPickerViewConfigurationsProtocol!
    
    var interactor: ConverterInteractorProtocol!
    var router: ConverterRouterProtocol!
    
    required init(view: ConverterViewProtocol) {
        self.view = view
    }
}

//MARK: - ProtocolProperties:
extension ConverterPresenter: ConverterPresenterProtocol {


    var originalCurrencyCode: String {
        get {
            guard let currency = interactor.originalCurrecyCode else {fatalError("Original currency not found")}
            return currency
        }
    }
    var conversionCurrencyCode: String {
        get{
            guard let currency = interactor.conversionCurrecyCode else {fatalError("Conversion currency not found")}
            return currency
        }
    }
    
    var originalAmountString: String {
        get {
            guard let sum = interactor.originalAmount else {fatalError("Original amount not found")}
            var strSum = String(sum)
            if strSum.hasSuffix(".0") {
                strSum.removeLast(2)
            }
            return strSum
        }
        set {
            interactor.originalAmount = Float(newValue) ?? 0.0
        }
    }
    
    var convertedAmountString: String {
        get {
            guard let sum = interactor.convertedAmount else {fatalError("Converted amount not found")}
            return sum.sum ?? "0.00"
        }
    }
}

//MARK: - ViewConfugurations
extension ConverterPresenter {
    
    func configure(_ viewController: ConverterViewController) {
      
        let interactor = ConverterInteractior(presenter: self)
        let router = ConverterRouter(viewController: viewController)
        
        viewController.presenter = self
        self.interactor = interactor
        self.router = router
        self.picker = viewController.pickerView
        viewController.pickerView.actionDelegate = self
        
        setupView()
    }
    
    private func setupView() {
        view.setOriginalCurrencyCode(originalCurrencyCode)
        view.setConversionCurrencyCode(conversionCurrencyCode)
        view.setOriginalAmount(originalAmountString)
        view.setConvertedAmount(convertedAmountString)
        interactor.loadCurrencies()
    }
}

//MARK: - UIFeedback
extension ConverterPresenter {
    
    func originalCurrencyButtonTapped() {
        interactor.originalCurrecyEditing()
        picker.currencies = interactor.setCurrencies()
        picker.selectedCurrencyCode = interactor.originalCurrecyCode
        picker.reloadRows()
        picker.scrollToDefaultValue()
        view.showPickeView()
    }
    func conversionCurrencyButtonTapped() {
        interactor.conversionCurrencyEditing()
        picker.currencies = interactor.setCurrencies()
        picker.selectedCurrencyCode = interactor.conversionCurrecyCode
        picker.reloadRows()
        picker.scrollToDefaultValue()
        view.showPickeView()
    }
    func textFieldBeginEditing() {
        originalAmountString = ""
    }
}

//MARK: - Delegating:
extension ConverterPresenter {
    
    func infoButtonTapped() {
        router.showProductViewController()
    }
    
    func originalCurrencyCodeChanged(_ value: String) {
        interactor.originalCurrecyCode = value
        view.setOriginalCurrencyCode(value)
    }
    
    func conversionCurrencyCodeChanged(_ value: String) {
        interactor.conversionCurrecyCode = value
        view.setConversionCurrencyCode(value)
    }
    
    func originalAmountChanged(_ value: String) {
        originalAmountString = value
        view.setOriginalAmount(value)
    }
    func updateValues() {
        view.setConvertedAmount(convertedAmountString)
    }
}

//MARK: - DelegatedActions
extension ConverterPresenter: CurrencyPickerViewDelegate {
    func applyCurrency(_ value: CurrencyEntity) {
        view.hidePickerView()
        interactor.currencyDidChange(value)
    }
    
    func cancel() {
        view.hidePickerView()
    }
}
