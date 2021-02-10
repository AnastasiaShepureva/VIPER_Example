//
//  ConverterViewController.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//

import UIKit

class ConverterViewController: UIViewController {
    //MARK: - Constants:
    var presenter: ConverterPresenterProtocol!
    
    //MARK: - UIElements:
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var originalCurrencyButton: UIButton!
    
    @IBOutlet weak var conversionCurrencyButton: UIButton!
    
    @IBOutlet weak var pickerView: CurrencyPickerView!
    
    @IBOutlet weak var infoButton: UIButton!
    
    //Tap gesture recognizer to close the keyboard
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    //MARK: - Actions:
    @IBAction func originalCurrencyButtonAction(_ sender: UIButton) {
        presenter.originalCurrencyButtonTapped()
    }
    
    @IBAction func conversionCurrencyButtonAction(_ sender: UIButton) {
        presenter.conversionCurrencyButtonTapped()
    }
    
    @IBAction func textFieldBeginEditing(_ sender: UITextField) {
        presenter.textFieldBeginEditing()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        guard let locationView = amountTextField else {fatalError("TextField didn't setup")}
        let location = sender.location(in: locationView)
        if !locationView.bounds.contains(location) {
            amountTextField.endEditing(true)
        }
    }
    @IBAction func infoBurronAction(_ sender: UIButton) {
        presenter.infoButtonTapped()
    }
    
    fileprivate func setupPresenter() {
        presenter = ConverterPresenter(view: self)
        presenter.configure(self)
        self.pickerView.alpha = 0
    }
    
    //MARK: -LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPresenter()
    }
}

//MARK: - ViewProtocolMethods
extension ConverterViewController: ConverterViewProtocol{
    func tapGestureToggle() {
        tapGestureRecognizer.isEnabled = !tapGestureRecognizer.isEnabled
    }
    
    func setOriginalAmount(_ value: String) {
        amountTextField.text = value
    }
    
    func setConvertedAmount(_ value: String) {
        DispatchQueue.main.async {
            self.resultLabel.text = value
        }
    }
    
    func setOriginalCurrencyCode(_ value: String) {
        originalCurrencyButton.setTitle(value, for: .normal)
    }
    
    func setConversionCurrencyCode(_ value: String) {
        conversionCurrencyButton.setTitle(value, for: .normal)
    }
    
    func showPickeView() {
        
        UIView.animate(withDuration: 0.3) {[self] in
            pickerView.alpha = 1
        }
    }
    
    func hidePickerView() {
        
        pickerView.alpha = 1
        UIView.animate(withDuration: 0.3) {[self] in
            pickerView.alpha = 0
        }
    }
    
    func infoButtonTapped() {
        presenter.infoButtonTapped()
    }
}
//MARK: - UITextFieldDelegate
extension ConverterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter.textFieldBeginEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        presenter.originalAmountChanged(textField.text!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else {return true}

        if text.first == "0" && !text.contains(".") {
            textField.text?.removeAll()
        }

        if !text.isEmpty {
            if string == "," {
                textField.insertText(".")
                return false
            }
            if text.contains(".") {
                var maxLenght: Int!
  
                guard let index: Int = text.firstIndex(of: ".")?.utf16Offset(in: text) else {return false}
                if index == 0 {
                    textField.text?.insert("0", at: string.startIndex)
                    maxLenght = 4
                }
                maxLenght = index + 3
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLenght
            }
        }
        return true
    }
}
