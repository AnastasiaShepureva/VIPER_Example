//
//  ConverterViewProtocol.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//


protocol ConverterViewProtocol: class {
    func setOriginalAmount(_ value: String)
    func setConvertedAmount(_ value: String)
    func setOriginalCurrencyCode(_ value: String)
    func setConversionCurrencyCode(_ value: String)
    func showPickeView()
    func hidePickerView()
    func infoButtonTapped()
    func tapGestureToggle()
}
