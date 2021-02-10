//
//  ProductViewController.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 05.02.2021.
//

import UIKit

class ProductViewController: UIViewController {
    //MARK: - Constants:
    
    var presenter: ProductPresenterProtocol!
    
    //MARK: - Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
    }

    //MARK: - UIElements&Actions:
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    
    @IBAction func urlButtonAction(_ sender: UIButton) {
        presenter.goToUrl(sender.currentTitle)
    }
    
    @IBAction func closeBarButtonItem(_ sender: UIBarButtonItem) {
        presenter.cancel()
    }
    
    fileprivate func setupPresenter() {
        presenter = ProductPresenter(view: self)
        presenter.configure(self)
    }
}
    //MARK: - ProductViewProtocol
extension ProductViewController: ProductViewProtocol {
    
    func configureBatton(_ title: String) {
        urlButton.setTitle(title, for: .normal)
    }
    
    func configureProductDescriptionLabel(_ string: String) {
        label.text = string
    }
    
}
